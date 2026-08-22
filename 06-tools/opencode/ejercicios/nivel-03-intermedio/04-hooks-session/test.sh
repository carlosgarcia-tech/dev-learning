#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/opencode.json" ] || { echo "Falta opencode.json"; exit 1; }
node -p "JSON.stringify(require('./$DIR/opencode.json').hooks?.onSessionStart || [])" | grep -q "git status" || { echo "Falta hook onSessionStart"; exit 1; }
echo "OK"
