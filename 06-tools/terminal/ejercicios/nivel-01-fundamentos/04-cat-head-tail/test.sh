#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/datos.txt" ] || { echo "Falta datos.txt"; exit 1; }
[ -f "$DIR/head.txt" ] || { echo "Falta head.txt"; exit 1; }
[ -f "$DIR/tail.txt" ] || { echo "Falta tail.txt"; exit 1; }
LINES=$(wc -l < "$DIR/head.txt")
[ "$LINES" -eq 5 ] || { echo "head.txt debe tener 5 líneas, tiene $LINES"; exit 1; }
echo "OK"
