#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "npm" "$DIR/respuesta.txt" || { echo "Falta npm"; exit 1; }
grep -qi "yarn" "$DIR/respuesta.txt" || { echo "Falta yarn"; exit 1; }
grep -qi "pnpm" "$DIR/respuesta.txt" || { echo "Falta pnpm"; exit 1; }
echo "OK"
