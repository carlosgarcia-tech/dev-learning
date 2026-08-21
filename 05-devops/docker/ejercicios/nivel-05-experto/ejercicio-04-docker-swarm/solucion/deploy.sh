#!/usr/bin/env bash
set -euo pipefail
docker build -t miapp:swarm ./app
docker swarm init 2>/dev/null || true
docker stack deploy -c docker-compose.yml miapp
