#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
VER=$(node -p "require('./$DIR/package.json').version || ''")
[[ "$VER" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Versión no es semver: $VER"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "patch" "$DIR/respuesta.txt" || { echo "No menciona patch"; exit 1; }
grep -qi "minor" "$DIR/respuesta.txt" || { echo "No menciona minor"; exit 1; }
grep -qi "major" "$DIR/respuesta.txt" || { echo "No menciona major"; exit 1; }
echo "OK"
