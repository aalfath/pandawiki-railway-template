# Qdrant vector database for PandaWiki's RAGLite (version upstream ships).
FROM qdrant/qdrant:v1.14.1@sha256:419d72603f5346ee22ffc4606bdb7beb52fcb63077766fab678e6622ba247366
# Listen dual-stack so Railway's private network reaches it.
ENV QDRANT__SERVICE__HOST=:: \
    QDRANT__TELEMETRY_DISABLED=true \
    QDRANT__SERVICE__MAX_WORKERS=2 \
    QDRANT__STORAGE__PERFORMANCE__MAX_SEARCH_THREADS=2 \
    QDRANT__STORAGE__PERFORMANCE__MAX_OPTIMIZATION_THREADS=1
