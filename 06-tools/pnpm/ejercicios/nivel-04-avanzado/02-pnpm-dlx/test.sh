#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/salida.txt" ] || { echo "Falta salida.txt"; exit 1; }
echo "OK"
