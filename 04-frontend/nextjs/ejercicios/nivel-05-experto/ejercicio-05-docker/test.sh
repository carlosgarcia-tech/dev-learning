#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Dockerfile" ]] && { echo "FAIL Tests fallaron"; echo "Falta Dockerfile"; exit 1; }
[[ ! -f "next.config.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta next.config.js"; exit 1; }
check_docker() { grep -qi "$1" "Dockerfile" || { echo "FAIL Tests fallaron"; echo "No se encontro en Dockerfile: $2"; exit 1; }; }
check_config() { grep -qi "$1" "next.config.js" || { echo "FAIL Tests fallaron"; echo "No se encontro en next.config.js: $2"; exit 1; }; }
check_docker 'FROM' "FROM"
check_docker 'npm run build\|npm ci' "npm build o ci"
check_docker 'EXPOSE' "EXPOSE"
check_docker 'server.js' "CMD server.js"
check_config 'standalone' "output standalone"
echo "OK Tests pasaron"
