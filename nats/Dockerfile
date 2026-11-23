# NATS with JetStream, PandaWiki's and RAGLite's task queue.
FROM nats:2.11.11-alpine@sha256:897156029e76f4663e89ca98a99a5ee1b03b37e2e75e956220f83d2a3e28f7b8
COPY nats.conf /etc/nats/pandawiki.conf
ENV GOMAXPROCS=2 \
    NATS_USER=panda-wiki
CMD ["nats-server", "-c", "/etc/nats/pandawiki.conf"]
