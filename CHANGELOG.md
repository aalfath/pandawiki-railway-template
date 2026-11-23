# Changelog

Each entry lists breaking changes first. Read it before you apply an update notice on Railway.

## v3.87.5 (2026-11-23)

First release of this template.

- PandaWiki 3.87.5 (API, consumer, admin console, wiki app), RAGLite 2.17.0, Qdrant 1.14.1, MinIO RELEASE.2025-04-22T22-12-26Z, NATS 2.11.11, Caddy 2.10.2, all pinned by version and digest.
- Admin account created on first boot from a generated `ADMIN_PASSWORD`; all other secrets generated.
- Qdrant, MinIO and NATS on their own volumes; PandaWiki data on `/data`; Railway Postgres and Redis.
- Worker and thread counts capped so each service runs within 0.5 GB RAM / 1 vCPU.
