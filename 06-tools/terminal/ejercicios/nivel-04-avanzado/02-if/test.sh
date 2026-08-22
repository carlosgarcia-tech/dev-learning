#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/par.sh" ] || { echo "Falta par.sh"; exit 1; }
RESULT=$(bash "$DIR/par.sh" 4)
[ "$RESULT" = "par" ] || { echo "Esperaba par, obtuve $RESULT"; exit 1; }
RESULT=$(bash "$DIR/par.sh" 5)
[ "$RESULT" = "impar" ] || { echo "Esperaba impar, obtuve $RESULT"; exit 1; }
echo "OK"
