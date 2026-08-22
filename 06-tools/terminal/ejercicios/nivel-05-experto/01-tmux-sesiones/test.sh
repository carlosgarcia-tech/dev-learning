#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "tmux new" "$DIR/respuesta.txt" || { echo "No menciona crear"; exit 1; }
grep -qi "attach" "$DIR/respuesta.txt" || { echo "No menciona attach"; exit 1; }
grep -qi "Ctrl+B" "$DIR/respuesta.txt" || { echo "No menciona detach"; exit 1; }
echo "OK"
