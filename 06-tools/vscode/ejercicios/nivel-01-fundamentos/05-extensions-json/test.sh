#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.vscode/extensions.json" ] || { echo "Falta extensions.json"; exit 1; }
COUNT=$(node -p "require('./$DIR/.vscode/extensions.json').recommendations?.length || 0")
[ "$COUNT" -ge 3 ] || { echo "Se necesitan al menos 3 recomendaciones"; exit 1; }
echo "OK"
