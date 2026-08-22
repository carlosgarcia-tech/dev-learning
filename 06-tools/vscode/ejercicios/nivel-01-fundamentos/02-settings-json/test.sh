#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/settings.json" ] || { echo "Falta settings.json"; exit 1; }
node -p "require('./$DIR/settings.json')['editor.fontSize']" | grep -q 14 || { echo "fontSize incorrecto"; exit 1; }
node -p "require('./$DIR/settings.json')['editor.formatOnSave']" | grep -q true || { echo "formatOnSave incorrecto"; exit 1; }
echo "OK"
