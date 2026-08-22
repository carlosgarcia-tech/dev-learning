#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
NAME=$(node -p "require('./$DIR/package.json').name || ''")
[[ "$NAME" == @* ]] || { echo "name debe ser scoped (@)"; exit 1; }
ACCESS=$(node -p "require('./$DIR/package.json').publishConfig?.access || ''")
[ "$ACCESS" = "public" ] || { echo "publishConfig.access debe ser public"; exit 1; }
echo "OK"
