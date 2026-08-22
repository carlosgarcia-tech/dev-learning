#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
F="$DIR/.npmrc"
[ -f "$F" ] || { echo "Falta .npmrc"; exit 1; }
grep -q "registry=" "$F" || { echo "Falta registry"; exit 1; }
grep -q "@miorg" "$F" || { echo "Falta scope @miorg"; exit 1; }
echo "OK"
