#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
node -p "require('./$DIR/package.json').private" | grep -q true || { echo "Falta private: true"; exit 1; }
WS=$(node -p "JSON.stringify(require('./$DIR/package.json').workspaces || [])")
echo "$WS" | grep -q "packages" || { echo "Falta workspaces"; exit 1; }
[ -f "$DIR/packages/core/package.json" ] || { echo "Falta packages/core"; exit 1; }
[ -f "$DIR/packages/ui/package.json" ] || { echo "Falta packages/ui"; exit 1; }
echo "OK"
