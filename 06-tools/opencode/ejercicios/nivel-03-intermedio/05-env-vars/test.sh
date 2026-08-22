#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "OPENCODE_API_KEY" "$DIR/respuesta.txt" || { echo "No menciona OPENCODE_API_KEY"; exit 1; }
echo "OK"
