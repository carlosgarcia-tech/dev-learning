#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/func.sh" ] || { echo "Falta func.sh"; exit 1; }
RESULT=$(bash "$DIR/func.sh")
echo "$RESULT" | grep -q "Hola, Ada" || { echo "La función no saluda correctamente: $RESULT"; exit 1; }
echo "OK"
