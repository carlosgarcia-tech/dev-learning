#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.vscode/tasks.json" ] || { echo "Falta tasks.json"; exit 1; }
LABEL=$(node -p "require('./$DIR/.vscode/tasks.json').tasks[0].label")
[ "$LABEL" = "build" ] || { echo "label debe ser build"; exit 1; }
echo "OK"
