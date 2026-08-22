#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/package.json" ] || { echo "Falta package.json"; exit 1; }
node -p "require('./$DIR/package.json').dependencies.express" | grep -q . || { echo "express no está en dependencies"; exit 1; }
node -p "require('./$DIR/package.json').devDependencies.jest" | grep -q . || { echo "jest no está en devDependencies"; exit 1; }
echo "OK"
