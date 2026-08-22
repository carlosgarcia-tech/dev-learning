#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/opencode.json" ] || { echo "Falta opencode.json"; exit 1; }
node -p "require('./$DIR/opencode.json').model" | grep -q . || { echo "Falta model"; exit 1; }
echo "OK"
