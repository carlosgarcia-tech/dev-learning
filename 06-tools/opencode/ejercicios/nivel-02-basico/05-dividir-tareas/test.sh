#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/tareas.txt" ] || { echo "Falta tareas.txt"; exit 1; }
LINES=$(grep -c "^[0-9]" "$DIR/tareas.txt")
[ "$LINES" -ge 4 ] || { echo "Se necesitan al menos 4 tareas, hay $LINES"; exit 1; }
echo "OK"
