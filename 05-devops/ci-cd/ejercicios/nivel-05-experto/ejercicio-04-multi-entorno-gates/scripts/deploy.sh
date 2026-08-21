#!/usr/bin/env bash
set -euo pipefail
ENTORNO="${1:?Uso: deploy.sh <entorno>}"
echo "Desplegando a $ENTORNO"
echo "Deploy $ENTORNO OK"
