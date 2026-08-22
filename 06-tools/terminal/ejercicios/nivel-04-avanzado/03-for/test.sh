#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/loop.sh" ] || { echo "Falta loop.sh"; exit 1; }
[ -f "$DIR/salida.txt" ] || { echo "Falta salida.txt (ejecuta loop.sh primero)"; exit 1; }
LINES=$(wc -l < "$DIR/salida.txt")
[ "$LINES" -eq 10 ] || { echo "Debe tener 10 líneas, tiene $LINES"; exit 1; }
echo "OK"
