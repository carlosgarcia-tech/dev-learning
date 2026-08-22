#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/frecuencia.txt" ] || { echo "Falta frecuencia.txt"; exit 1; }
grep -q "Ada" "$DIR/frecuencia.txt" || { echo "Falta Ada"; exit 1; }
echo "OK"
