#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/opencode.json" ] || { echo "Falta opencode.json"; exit 1; }
node -p "JSON.stringify(require('./$DIR/opencode.json').hooks?.postToolUse || [])" | grep -q "lint" || { echo "Falta hook postToolUse"; exit 1; }
echo "OK"
