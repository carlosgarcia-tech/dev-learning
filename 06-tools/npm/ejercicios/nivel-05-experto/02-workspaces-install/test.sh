#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -d "$DIR/node_modules" ] || { echo "Falta node_modules"; exit 1; }
DEP=$(node -p "require('./$DIR/packages/core/package.json').dependencies?.express || ''")
[ -n "$DEP" ] || { echo "express no está en packages/core"; exit 1; }
echo "OK"
