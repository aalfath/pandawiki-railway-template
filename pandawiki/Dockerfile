# PandaWiki API + document consumer + admin console, for Railway.
# Upstream images: https://github.com/chaitin/PandaWiki (release v3.87.5).
FROM chaitin-registry.cn-hangzhou.cr.aliyuncs.com/chaitin/panda-wiki-consumer:v3.87.5@sha256:ce175c8a66fecff9416383fbeabe6c6f9f0d1d089062a1a53adc7bb9a5510089 AS consumer
FROM chaitin-registry.cn-hangzhou.cr.aliyuncs.com/chaitin/panda-wiki-nginx:v3.87.5@sha256:8132e209acc54ff29ac2f8144d88fcc750d59a88e7c282d261dfbd67a84c2b31 AS admin
FROM caddy:2.10.2-alpine@sha256:4c6e91c6ed0e2fa03efd5b44747b625fec79bc9cd06ac5235a779726618e530d AS caddy

FROM chaitin-registry.cn-hangzhou.cr.aliyuncs.com/chaitin/panda-wiki-api:v3.87.5@sha256:da0125ef7dfdbbf66376e9ef3a65add9663a71d50132b1ee34b04ab135c8abf5
COPY --from=consumer /app/panda-wiki-consumer /app/panda-wiki-consumer
COPY --from=admin /opt/frontend/dist /opt/frontend/dist
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
RUN chmod +x /start.sh
# SUBNET_PREFIX=127.0.0 turns the peer addresses the API hard-codes for its
# Caddy routes (127.0.0.112:3010 wiki front end, 127.0.0.12:9000 MinIO) into
# loopback addresses that the bundled Caddy forwards over Railway's private network.
ENV SUBNET_PREFIX=127.0.0 \
    CADDY_API=/run/caddy/admin.sock \
    SENTRY_ENABLED=false \
    GOMAXPROCS=2 \
    TZ=UTC
CMD ["/start.sh"]
