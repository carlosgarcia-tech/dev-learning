#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "node_modules\|package-lock" "$DIR/respuesta.txt" || { echo "No menciona qué borrar"; exit 1; }
grep -qi "pnpm install" "$DIR/respuesta.txt" || { echo "No menciona pnpm install"; exit 1; }
echo "OK"
