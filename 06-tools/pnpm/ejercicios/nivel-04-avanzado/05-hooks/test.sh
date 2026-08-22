#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
node -p "require('./$DIR/package.json').scripts.prebuild" | grep -q . || { echo "Falta prebuild"; exit 1; }
node -p "require('./$DIR/package.json').scripts.build" | grep -q . || { echo "Falta build"; exit 1; }
node -p "require('./$DIR/package.json').scripts.postbuild" | grep -q . || { echo "Falta postbuild"; exit 1; }
echo "OK"
