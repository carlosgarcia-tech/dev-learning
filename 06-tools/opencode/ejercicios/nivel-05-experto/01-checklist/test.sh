#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/checklist.txt" ] || { echo "Falta checklist.txt"; exit 1; }
LINES=$(grep -c "\[ \]" "$DIR/checklist.txt")
[ "$LINES" -ge 5 ] || { echo "Se necesitan al menos 5 items, hay $LINES"; exit 1; }
echo "OK"
