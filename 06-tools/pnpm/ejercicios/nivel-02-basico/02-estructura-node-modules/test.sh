#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -d "$DIR/node_modules/.pnpm" ] || { echo "Falta .pnpm"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "pnpm\|symlink\|plano" "$DIR/respuesta.txt" || { echo "Respuesta incompleta"; exit 1; }
echo "OK"
