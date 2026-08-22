#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/settings.json" ] || { echo "Falta settings.json"; exit 1; }
node -p "require('./$DIR/settings.json')['editor.formatOnSave']" | grep -q true || { echo "formatOnSave debe ser true"; exit 1; }
node -p "require('./$DIR/settings.json')['[javascript]']['editor.defaultFormatter']" | grep -q prettier || { echo "Falta prettier"; exit 1; }
echo "OK"
