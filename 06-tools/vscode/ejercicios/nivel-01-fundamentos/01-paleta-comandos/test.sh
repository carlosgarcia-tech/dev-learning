#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Ctrl+Shift+P\|Cmd+Shift+P" "$DIR/respuesta.txt" || { echo "No menciona el atajo"; exit 1; }
echo "OK"
