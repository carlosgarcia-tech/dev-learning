#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
BS=$(node -p "require('./$DIR/packages/core/package.json').scripts?.build || ''")
[ -n "$BS" ] || { echo "Falta script build en core"; exit 1; }
echo "OK"
