#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.vscode/tasks.json" ] || { echo "Falta tasks.json"; exit 1; }
node -p "require('./$DIR/.vscode/tasks.json').tasks[0].problemMatcher" | grep -q tsc || { echo "Falta problemMatcher \$tsc"; exit 1; }
echo "OK"
