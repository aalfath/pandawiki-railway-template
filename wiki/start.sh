#!/bin/sh
# Runs the Next.js wiki server on :3010 and Caddy on $PORT. Exits non-zero
# when either stops, so Railway's ON_FAILURE restart policy brings it back.
set -u
: "${PORT:=8080}"
: "${PANDAWIKI_HOST:?PANDAWIKI_HOST is not set}"
: "${TARGET:?TARGET is not set}"
export PORT PANDAWIKI_HOST
mkdir -p /tmp/caddy/data /tmp/caddy/config
cd /app
PORT=3010 HOSTNAME="${WIKI_BIND:-::}" node app/server.js &
NODE_PID=$!
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
CADDY_PID=$!
trap 'kill $NODE_PID $CADDY_PID 2>/dev/null; wait; exit 0' TERM INT
while kill -0 $NODE_PID 2>/dev/null && kill -0 $CADDY_PID 2>/dev/null; do sleep 3; done
echo "start: a process exited, stopping container"
kill $NODE_PID $CADDY_PID 2>/dev/null
exit 1
