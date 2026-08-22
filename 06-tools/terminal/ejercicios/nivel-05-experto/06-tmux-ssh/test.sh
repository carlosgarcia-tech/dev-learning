#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "ssh" "$DIR/respuesta.txt" || { echo "No menciona ssh"; exit 1; }
grep -qi "tmux" "$DIR/respuesta.txt" || { echo "No menciona tmux"; exit 1; }
grep -qi "detach\|Ctrl+B" "$DIR/respuesta.txt" || { echo "No menciona detach"; exit 1; }
echo "OK"
