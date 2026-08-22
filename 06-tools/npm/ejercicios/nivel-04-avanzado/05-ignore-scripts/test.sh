#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
F="$DIR/.npmrc"
[ -f "$F" ] || { echo "Falta .npmrc"; exit 1; }
grep -q "ignore-scripts=true" "$F" || { echo "Falta ignore-scripts=true"; exit 1; }
echo "OK"
