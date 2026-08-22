#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
DEV=$(node -p "require('./$DIR/package.json').scripts.dev || ''")
SAL=$(node -p "require('./$DIR/package.json').scripts.saludar || ''")
[[ "$DEV" == *"node --watch"* ]] || { echo "Falta script dev"; exit 1; }
[[ "$SAL" == *Hola* ]] || { echo "Falta script saludar"; exit 1; }
echo "OK"
