#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
node -p "require('./$DIR/packages/core/package.json').scripts?.test || ''" | grep -q . || { echo "Falta test en core"; exit 1; }
node -p "require('./$DIR/packages/ui/package.json').scripts?.test || ''" | grep -q . || { echo "Falta test en ui"; exit 1; }
[ -f "$DIR/respuesta.txt" ] && grep -qi "recursi\|todos\|workspace" "$DIR/respuesta.txt" || { echo "Falta respuesta.txt correcta"; exit 1; }
echo "OK"
