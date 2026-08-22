#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/javascript.json" ] || { echo "Falta javascript.json"; exit 1; }
PREFIX=$(node -p "Object.values(require('./$DIR/javascript.json'))[0].prefix")
[ "$PREFIX" = "clg" ] || { echo "prefix debe ser clg"; exit 1; }
echo "OK"
