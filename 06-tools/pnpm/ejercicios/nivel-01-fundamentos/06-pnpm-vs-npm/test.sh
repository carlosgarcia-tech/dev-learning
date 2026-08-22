#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "pnpm install" "$DIR/respuesta.txt" || { echo "Falta pnpm install"; exit 1; }
grep -qi "pnpm add" "$DIR/respuesta.txt" || { echo "Falta pnpm add"; exit 1; }
grep -qi "dlx\|exec" "$DIR/respuesta.txt" || { echo "Falta dlx/exec"; exit 1; }
echo "OK"
