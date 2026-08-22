#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/Dockerfile" ] || { echo "Falta Dockerfile"; exit 1; }
grep -q "corepack enable" "$DIR/Dockerfile" || { echo "Falta corepack"; exit 1; }
grep -q "frozen-lockfile" "$DIR/Dockerfile" || { echo "Falta frozen-lockfile"; exit 1; }
grep -q "prod" "$DIR/Dockerfile" || { echo "Falta --prod"; exit 1; }
echo "OK"
