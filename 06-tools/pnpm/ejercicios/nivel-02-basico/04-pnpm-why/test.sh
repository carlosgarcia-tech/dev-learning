#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/why.txt" ] || { echo "Falta why.txt"; exit 1; }
echo "OK"
