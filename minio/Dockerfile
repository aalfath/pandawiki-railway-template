# MinIO object storage for PandaWiki uploads (the build upstream's installer ships).
FROM chaitin-registry.cn-hangzhou.cr.aliyuncs.com/chaitin/panda-wiki-minio:RELEASE.2025-04-22T22-12-26Z-cpuv1@sha256:38c8b4f272f2d76366248416da20120bca7b654e36ac05fe470e4434093b24f8
ENV GOMAXPROCS=2 \
    MINIO_ROOT_USER=s3panda-wiki \
    MINIO_BROWSER=off
CMD ["minio", "server", "/data", "--address", ":9000"]
