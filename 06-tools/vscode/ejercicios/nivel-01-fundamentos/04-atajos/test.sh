#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Ctrl+P" "$DIR/respuesta.txt" || { echo "Falta Quick Open"; exit 1; }
grep -qi "Ctrl+B" "$DIR/respuesta.txt" || { echo "Falta toggle sidebar"; exit 1; }
grep -qi "F12" "$DIR/respuesta.txt" || { echo "Falta Go to definition"; exit 1; }
echo "OK"
