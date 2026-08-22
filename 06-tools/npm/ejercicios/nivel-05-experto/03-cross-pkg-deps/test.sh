#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
DEP=$(node -p "require('./$DIR/packages/ui/package.json').dependencies?.['@miorg/core'] || ''")
[ -n "$DEP" ] || { echo "@miorg/core no está en dependencies de ui"; exit 1; }
echo "OK"
