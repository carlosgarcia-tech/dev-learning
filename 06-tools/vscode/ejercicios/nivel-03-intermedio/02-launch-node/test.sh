#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.vscode/launch.json" ] || { echo "Falta launch.json"; exit 1; }
TYPE=$(node -p "require('./$DIR/.vscode/launch.json').configurations[0].type")
[ "$TYPE" = "node" ] || { echo "type debe ser node"; exit 1; }
echo "OK"
