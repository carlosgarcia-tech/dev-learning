#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/resultado.txt" ] || { echo "Falta resultado.txt"; exit 1; }
grep -qE "^[0-9]+$" "$DIR/resultado.txt" || { echo "No es un número"; exit 1; }
echo "OK"
