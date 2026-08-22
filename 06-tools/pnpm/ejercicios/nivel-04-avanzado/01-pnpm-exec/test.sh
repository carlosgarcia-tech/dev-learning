#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/version.txt" ] || { echo "Falta version.txt"; exit 1; }
echo "OK"
