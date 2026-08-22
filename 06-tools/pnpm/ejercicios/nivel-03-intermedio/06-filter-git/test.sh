#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "main\|origin\|filter" "$DIR/respuesta.txt" || { echo "No menciona main/filter"; exit 1; }
echo "OK"
