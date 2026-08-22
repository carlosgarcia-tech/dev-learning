#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/config-nueva.txt" ] || { echo "Falta config-nueva.txt"; exit 1; }
grep -q "8080" "$DIR/config-nueva.txt" || { echo "No se hizo la sustitución"; exit 1; }
echo "OK"
