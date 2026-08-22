#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
OV=$(node -p "JSON.stringify(require('./$DIR/package.json').overrides || {})")
echo "$OV" | grep -q lodash || { echo "Falta override de lodash"; exit 1; }
echo "$OV" | grep -q "4.17.21" || { echo "Versión incorrecta"; exit 1; }
echo "OK"
