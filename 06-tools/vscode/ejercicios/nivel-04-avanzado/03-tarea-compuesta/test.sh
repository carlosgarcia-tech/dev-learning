#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.vscode/tasks.json" ] || { echo "Falta tasks.json"; exit 1; }
node -p "require('./$DIR/.vscode/tasks.json').tasks[0].label" | grep -q "ci" || { echo "Falta tarea ci"; exit 1; }
node -p "require('./$DIR/.vscode/tasks.json').tasks[0].dependsOn.length" | grep -q 3 || { echo "Faltan dependencias"; exit 1; }
echo "OK"
