#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "publish" "$DIR/respuesta.txt" || { echo "No menciona publish"; exit 1; }
grep -qi "\-w\b\|workspace" "$DIR/respuesta.txt" || { echo "No menciona -w o workspace"; exit 1; }
echo "OK"
