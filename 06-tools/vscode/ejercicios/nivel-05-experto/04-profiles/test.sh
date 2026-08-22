#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Create Profile\|crear" "$DIR/respuesta.txt" || { echo "No menciona crear"; exit 1; }
echo "OK"
