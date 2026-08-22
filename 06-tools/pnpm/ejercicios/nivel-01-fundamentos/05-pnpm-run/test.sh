#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
SAL=$(node -p "require('./$DIR/package.json').scripts.saludar || ''")
echo "$SAL" | grep -qi "hola" || { echo "Script saludar incorrecto"; exit 1; }
echo "OK"
