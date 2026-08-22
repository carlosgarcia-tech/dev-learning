#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "opencode run" "$DIR/respuesta.txt" || { echo "No menciona opencode run"; exit 1; }
grep -qi "auto" "$DIR/respuesta.txt" || { echo "No menciona --auto"; exit 1; }
echo "OK"
