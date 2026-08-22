#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "phantom" "$DIR/respuesta.txt" || { echo "No menciona phantom"; exit 1; }
grep -qi "pnpm\|hoisting\|estrict" "$DIR/respuesta.txt" || { echo "No menciona pnpm/hoisting"; exit 1; }
echo "OK"
