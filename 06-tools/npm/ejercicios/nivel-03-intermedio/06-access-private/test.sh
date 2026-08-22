#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
ACCESS=$(node -p "require('./$DIR/package.json').publishConfig?.access || ''")
[ "$ACCESS" = "restricted" ] || { echo "access debe ser restricted, es: $ACCESS"; exit 1; }
echo "OK"
