# Qdrant vector database for PandaWiki's RAGLite (version upstream ships).
FROM qdrant/qdrant:v1.14.1@sha256:419d72603f5346ee22ffc4606bdb7beb52fcb63077766fab678e6622ba247366
# Listen dual-stack so Railway's private network reaches it. Segment count, WAL
# size and threads are capped so Qdrant fits in 0.5 GB (it would otherwise size
# them from the host's CPU count).
ENV QDRANT__SERVICE__HOST=:: \
    QDRANT__TELEMETRY_DISABLED=true \
    QDRANT__SERVICE__MAX_WORKERS=2 \
    QDRANT__STORAGE__PERFORMANCE__MAX_SEARCH_THREADS=2 \
    QDRANT__STORAGE__PERFORMANCE__MAX_OPTIMIZATION_THREADS=1 \
    QDRANT__STORAGE__OPTIMIZERS__DEFAULT_SEGMENT_NUMBER=2 \
    QDRANT__STORAGE__WAL__WAL_CAPACITY_MB=8
