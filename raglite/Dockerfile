# RAGLite, PandaWiki's retrieval service (document chunking, embeddings, search).
# Settings come from the environment (DATABASE_POSTGRESQL_HOST, NATS_URL, ...).
FROM chaitin-registry.cn-hangzhou.cr.aliyuncs.com/chaitin/raglite:v2.17.0@sha256:d89bee75f29a8be8c8ff7010a78908d952c8418df005a9244e3610ee5f0a0688
ENV GIN_MODE=release \
    GOMAXPROCS=2 \
    WORKER_CONCURRENCY=2 \
    EMBEDDER_RPM=800 \
    LLM_RPM=50 \
    NATS_USER=panda-wiki \
    STORAGE_MINIO_ACCESS_KEY_ID=s3panda-wiki \
    DATABASE_POSTGRESQL_SSL_MODE=disable
CMD ["raglite", "-c", "/app/configs/config.yaml"]
