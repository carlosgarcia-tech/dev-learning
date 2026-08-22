#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/outdated.txt" ] || { echo "Falta outdated.txt"; exit 1; }
node -p "require('./$DIR/package.json').dependencies.lodash" | grep -q . || { echo "lodash no está declarado"; exit 1; }
echo "OK"
