[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/pandawiki?utm_medium=integration&utm_source=button&utm_campaign=pandawiki)

# Deploy and Host PandaWiki on Railway

PandaWiki is an open-source, AI-powered knowledge base by Chaitin Tech. You write and organise documents in a rich editor, publish them as a public or private wiki site, and let visitors search and ask questions answered from your own content with the LLM, embedding and rerank models you connect.

## About Hosting PandaWiki

PandaWiki is a stack of cooperating services. The Go API serves the admin console and runs migrations and the document consumer. A Next.js app renders the wiki sites. RAGLite chunks and indexes documents into Qdrant for semantic search, NATS carries events between them, MinIO stores uploaded files, and Postgres and Redis hold the data and sessions. This template deploys version 3.87.5 as eight Railway services wired over the private network, with every secret generated and every stateful service on its own volume. The admin account is created on first boot from a generated password, so nobody can claim it before you. You only need to connect your AI models after deploy.

## Common Use Cases

* Product documentation and help centre with AI search and Q&A
* Internal team wiki or company knowledge base
* FAQ site whose answers come from your own documents

## Dependencies for PandaWiki Hosting

* An OpenAI-compatible (or other supported) provider for chat, embedding, rerank and analysis models, added in the admin console after deploy
* About 2 GB of RAM across all services (no single service needs more than 0.5 GB at idle)

### Deployment Dependencies

* PandaWiki upstream: https://github.com/chaitin/PandaWiki
* Template source and changelog: https://github.com/aalfath/pandawiki-railway-template
* Docker images used (pinned by version and digest): `chaitin/panda-wiki-api`, `panda-wiki-consumer`, `panda-wiki-nginx`, `panda-wiki-app` and `raglite` from Chaitin's registry, `qdrant/qdrant`, Chaitin's MinIO build, `nats` and `caddy`

### Implementation Details

Services in this template:

| Service | What it does |
| --- | --- |
| PandaWiki | API, migrations, document consumer and the admin console (public domain, health check `/healthz`) |
| Wiki | Next.js front end for your published wiki sites (public domain) |
| RAGLite | Chunks, embeds and indexes documents for AI search and Q&A |
| Qdrant | Vector database for RAGLite (volume, API key generated) |
| MinIO | Object storage for uploaded images and files (volume, password generated) |
| NATS | Message queue with JetStream between the API and RAGLite (volume, password generated) |
| Postgres | Main database for PandaWiki and RAGLite |
| Redis | Cache and sessions |

After deploy:

1. Open the PandaWiki service's public domain. Sign in as `admin` with the password in the PandaWiki service's `ADMIN_PASSWORD` variable.
2. Go to the model settings and add a chat, embedding, rerank and analysis model (any OpenAI-compatible API works). PandaWiki needs these before you can create a knowledge base.
3. Create a knowledge base. For its address, enter the **Wiki** service's public domain, HTTP port `80`, and leave HTTPS off (Railway already serves the site over HTTPS). Write documents, then release them to publish them on the Wiki domain.

Updates: each service builds from the template repo, which pins every image by version and digest. When we release a new PandaWiki version, Railway shows an "update available" notice on your project; read `CHANGELOG.md` in the repo, then apply it when it suits you. Data stays on the volumes and in Postgres.

Left out on purpose: the `anydoc` crawler (only needed to import from URLs, Notion and similar sources; manual writing and file uploads work), the MinIO web console, and upstream's host-network installer. Upstream's Postgres build adds Chinese full-text search (zhparser); this template uses Railway's Postgres, so vector search works but Chinese keyword search is disabled.

## Why Deploy PandaWiki on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying PandaWiki on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
