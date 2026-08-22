#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/pnpm-workspace.yaml" ] || { echo "Falta pnpm-workspace.yaml"; exit 1; }
grep -q "packages" "$DIR/pnpm-workspace.yaml" || { echo "Falta packages"; exit 1; }
node -p "require('./$DIR/package.json').private" | grep -q true || { echo "Falta private"; exit 1; }
[ -f "$DIR/packages/core/package.json" ] || { echo "Falta core"; exit 1; }
[ -f "$DIR/packages/ui/package.json" ] || { echo "Falta ui"; exit 1; }
echo "OK"
