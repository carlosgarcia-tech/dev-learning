#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "stage\|\+" "$DIR/respuesta.txt" || { echo "No menciona stage"; exit 1; }
grep -qi "commit" "$DIR/respuesta.txt" || { echo "No menciona commit"; exit 1; }
echo "OK"
