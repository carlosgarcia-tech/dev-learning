#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/opencode.json" ] || { echo "Falta opencode.json"; exit 1; }
EDIT=$(node -p "require('./$DIR/opencode.json').permissions?.edit || ''")
[ "$EDIT" = "ask" ] || { echo "edit debe ser ask"; exit 1; }
echo "OK"
