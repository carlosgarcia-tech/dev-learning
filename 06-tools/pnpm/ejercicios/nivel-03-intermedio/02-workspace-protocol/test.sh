#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
DEP=$(node -p "require('./$DIR/packages/ui/package.json').dependencies?.['@miorg/core'] || ''")
[ "$DEP" = "workspace:*" ] || { echo "Debe ser workspace:*, es: $DEP"; exit 1; }
echo "OK"
