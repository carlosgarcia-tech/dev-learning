#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/salida.txt" ] || { echo "Falta salida.txt"; exit 1; }
grep -q "hola" "$DIR/salida.txt" || { echo "salida.txt no contiene hola"; exit 1; }
echo "OK"
