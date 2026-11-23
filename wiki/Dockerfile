# PandaWiki wiki front end (Next.js) behind a small Caddy, for Railway.
FROM caddy:2.10.2-alpine@sha256:4c6e91c6ed0e2fa03efd5b44747b625fec79bc9cd06ac5235a779726618e530d AS caddy

FROM chaitin-registry.cn-hangzhou.cr.aliyuncs.com/chaitin/panda-wiki-app:v3.87.5@sha256:4cf7bd5ccb22340b81351ab279ded80a1fcc024cba6ed46b99b43d6668a79036
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY --chmod=755 start.sh /start.sh
ENV NEXT_TELEMETRY_DISABLED=1 \
    XDG_DATA_HOME=/tmp/caddy/data \
    XDG_CONFIG_HOME=/tmp/caddy/config
CMD ["/start.sh"]
