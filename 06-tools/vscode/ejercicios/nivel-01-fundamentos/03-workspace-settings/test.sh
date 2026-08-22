#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.vscode/settings.json" ] || { echo "Falta .vscode/settings.json"; exit 1; }
node -p "require('./$DIR/.vscode/settings.json')['editor.defaultFormatter']" | grep -q . || { echo "Falta defaultFormatter"; exit 1; }
echo "OK"
