#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Ctrl" "$DIR/respuesta.txt" || { echo "No menciona atajo"; exit 1; }
echo "OK"
