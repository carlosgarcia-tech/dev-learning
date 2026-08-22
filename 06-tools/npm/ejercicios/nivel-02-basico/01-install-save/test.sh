#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
DEPS=$(node -p "require('./$DIR/package.json').dependencies || {}")
echo "$DEPS" | grep -q express || { echo "express falta"; exit 1; }
node -p "require('./$DIR/package.json').devDependencies.nodemon" | grep -q . || { echo "nodemon falta"; exit 1; }
LO=$(node -p "require('./$DIR/package.json').dependencies.lodash || ''")
[[ "$LO" =~ ^[0-9] ]] || { echo "lodash debe ser exacto (sin ^)"; exit 1; }
echo "OK"
