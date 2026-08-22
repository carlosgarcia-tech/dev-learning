#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.eslintrc.json" ] || { echo "Falta .eslintrc.json"; exit 1; }
node -p "require('./$DIR/.eslintrc.json').extends" | grep -q prettier || { echo "Falta prettier en extends"; exit 1; }
echo "OK"
