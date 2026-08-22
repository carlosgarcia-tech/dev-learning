#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/pnpm-lock.yaml" ] || { echo "Falta pnpm-lock.yaml"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "versión\|version\|dependencia" "$DIR/respuesta.txt" || { echo "Respuesta incompleta"; exit 1; }
echo "OK"
