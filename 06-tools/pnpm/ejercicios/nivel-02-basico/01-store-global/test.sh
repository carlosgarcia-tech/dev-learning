#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/store-path.txt" ] || { echo "Falta store-path.txt"; exit 1; }
[ -f "$DIR/store-status.txt" ] || { echo "Falta store-status.txt"; exit 1; }
echo "OK"
