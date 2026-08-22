#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "output json\|--output" "$DIR/respuesta.txt" || { echo "No menciona --output json"; exit 1; }
echo "OK"
