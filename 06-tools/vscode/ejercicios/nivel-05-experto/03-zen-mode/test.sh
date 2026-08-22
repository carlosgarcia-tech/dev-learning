#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Ctrl+K" "$DIR/respuesta.txt" || { echo "No menciona cómo activar"; exit 1; }
grep -qi "Esc" "$DIR/respuesta.txt" || { echo "No menciona cómo desactivar"; exit 1; }
echo "OK"
