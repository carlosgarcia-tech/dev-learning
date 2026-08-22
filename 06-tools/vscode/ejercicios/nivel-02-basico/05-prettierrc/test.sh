#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.prettierrc" ] || { echo "Falta .prettierrc"; exit 1; }
node -p "require('./$DIR/.prettierrc').singleQuote" | grep -q true || { echo "singleQuote debe ser true"; exit 1; }
echo "OK"
