#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/version.txt" ] || { echo "Falta version.txt"; exit 1; }
grep -qE "^[0-9]+\.[0-9]+" "$DIR/version.txt" || { echo "Versión inválida"; exit 1; }
echo "OK"
