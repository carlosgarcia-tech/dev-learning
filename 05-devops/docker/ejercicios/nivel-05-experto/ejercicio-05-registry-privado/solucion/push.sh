#!/usr/bin/env bash
set -euo pipefail
docker build -t miapp:1.0 ./app
docker tag miapp:1.0 localhost:5000/miapp:1.0
docker push localhost:5000/miapp:1.0
echo "OK: imagen subida a registry privado"
