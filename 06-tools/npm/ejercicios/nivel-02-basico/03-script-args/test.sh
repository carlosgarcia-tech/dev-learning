#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
SCRIPT=$(node -p "require('./$DIR/package.json').scripts.echo || ''")
[[ "$SCRIPT" == *console.log* ]] || { echo "El script echo no existe o es incorrecto"; exit 1; }
echo "OK"
