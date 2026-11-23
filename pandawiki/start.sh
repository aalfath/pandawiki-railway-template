#!/bin/sh
# Starts PandaWiki's processes in one container and exits non-zero as soon as
# any of them stops, so Railway's ON_FAILURE restart policy brings it back.
set -u
: "${PORT:=8080}"
export PORT
: "${WIKI_HOST:?WIKI_HOST is not set}"
: "${S3_ENDPOINT:?S3_ENDPOINT is not set}"
: "${PG_DSN:?PG_DSN is not set}"
: "${ADMIN_PASSWORD:?ADMIN_PASSWORD is not set}"
: "${JWT_SECRET:?JWT_SECRET is not set}"

# Values PandaWiki reads only from its config file (no env override upstream).
mkdir -p /app/config
cat > /app/config/config.yml <<CFG
rag:
  provider: ct
  ct_rag:
    api_key: "${RAG_API_KEY:-}"
s3:
  access_key: "${S3_ACCESS_KEY:-s3panda-wiki}"
CFG

export XDG_DATA_HOME=/tmp/caddy/data XDG_CONFIG_HOME=/tmp/caddy/config
mkdir -p /run/caddy /tmp/caddy/data /tmp/caddy/config
rm -f "$CADDY_API"

PIDS=""
stop() { [ -n "$PIDS" ] && kill $PIDS 2>/dev/null; wait; exit "${1:-0}"; }
trap 'stop 0' TERM INT

wait_tcp() { # host:port label tries
	h=${1%:*}; p=${1##*:}; h=${h#[}; h=${h%]}
	i=0
	until nc -z -w 2 "$h" "$p" 2>/dev/null; do
		i=$((i + 1))
		if [ "$i" -ge "$3" ]; then echo "start: $2 ($1) not reachable, giving up"; exit 1; fi
		[ $((i % 10)) -eq 1 ] && echo "start: waiting for $2 ($1)"
		sleep 2
	done
}

pg_host=$(echo "$PG_DSN" | sed -n 's/.*host=\([^ ]*\).*/\1/p')
pg_port=$(echo "$PG_DSN" | sed -n 's/.*port=\([0-9]*\).*/\1/p')
wait_tcp "$pg_host:${pg_port:-5432}" Postgres 90
wait_tcp "$REDIS_ADDR" Redis 90
nats=${MQ_NATS_SERVER#nats://}
wait_tcp "$nats" NATS 90
wait_tcp "$S3_ENDPOINT" MinIO 90
rag=${RAG_CT_RAG_BASE_URL#http://}; rag=${rag%%/*}
wait_tcp "$rag" RAGLite 120

# 1. API-managed Caddy (admin API on a unix socket, config pushed by the API).
cd /tmp && CADDY_ADMIN="unix/$CADDY_API" caddy run &
PIDS="$PIDS $!"
i=0; until [ -S "$CADDY_API" ]; do i=$((i + 1)); [ "$i" -ge 30 ] && { echo "start: caddy socket missing"; stop 1; }; sleep 1; done

# 2. Database migrations (golang-migrate takes a Postgres advisory lock).
cd /app
n=0
until ./panda-wiki-migrate; do
	n=$((n + 1)); [ "$n" -ge 5 ] && { echo "start: migration failed"; stop 1; }
	sleep 5
done

# 3. API, then the document consumer, then the admin console (health check).
./panda-wiki-api &
PIDS="$PIDS $!"
i=0; until nc -z -w 2 127.0.0.1 8000 2>/dev/null; do
	i=$((i + 1)); [ "$i" -ge 90 ] && { echo "start: API did not open :8000"; stop 1; }
	kill -0 $PIDS 2>/dev/null || { echo "start: API exited"; stop 1; }
	sleep 1
done
./panda-wiki-consumer &
PIDS="$PIDS $!"
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
PIDS="$PIDS $!"
echo "start: PandaWiki is up (admin console on :$PORT)"

while :; do
	for p in $PIDS; do
		if ! kill -0 "$p" 2>/dev/null; then
			echo "start: process $p exited, stopping container"
			stop 1
		fi
	done
	sleep 3
done
