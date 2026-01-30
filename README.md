# UniZ Infrastructure

**Repository**: `uniz-infra`
**Role**: DevOps & Deployment Configuration.

## Contents
*   `docker/`: Docker Compose files for local development.
*   `nginx/`: NGINX configurations for Gateway load balancing (future).

## Quick Start (Local Dev)
```bash
cd docker
docker-compose up --build
```
This starts Redis, Postgres, and all 5 microservices.
