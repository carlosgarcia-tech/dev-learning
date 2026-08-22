#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Ctrl+B" "$DIR/respuesta.txt" || { echo "No menciona prefix"; exit 1; }
grep -qi "%" "$DIR/respuesta.txt" || { echo "No menciona dividir vertical"; exit 1; }
echo "OK"
