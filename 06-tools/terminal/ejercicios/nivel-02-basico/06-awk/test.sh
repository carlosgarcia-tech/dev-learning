#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/datos.csv" ] || { echo "Falta datos.csv"; exit 1; }
[ -f "$DIR/nombres.txt" ] || { echo "Falta nombres.txt"; exit 1; }
grep -q "Ada" "$DIR/nombres.txt" || { echo "nombres.txt no tiene Ada"; exit 1; }
! grep -q "," "$DIR/nombres.txt" || { echo "nombres.txt no debe tener comas"; exit 1; }
echo "OK"
