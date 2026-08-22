#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/audit.txt" ] || { echo "Falta audit.txt"; exit 1; }
echo "OK"
