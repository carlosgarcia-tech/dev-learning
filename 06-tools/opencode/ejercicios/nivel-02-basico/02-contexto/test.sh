#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "referencia\|archivo" "$DIR/respuesta.txt" || { echo "No menciona referencias"; exit 1; }
echo "OK"
