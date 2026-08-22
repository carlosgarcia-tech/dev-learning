#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -d "$DIR/node_modules" ] || { echo "Falta node_modules"; exit 1; }
[ -f "$DIR/pnpm-lock.yaml" ] || { echo "Falta pnpm-lock.yaml"; exit 1; }
echo "OK"
