#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -q "pwd" "$DIR/respuesta.txt" || { echo "Falta pwd"; exit 1; }
grep -q "cd .." "$DIR/respuesta.txt" || { echo "Falta cd .."; exit 1; }
grep -q "cd -" "$DIR/respuesta.txt" || { echo "Falta cd -"; exit 1; }
echo "OK"
