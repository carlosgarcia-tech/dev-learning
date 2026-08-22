#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "diff\|revisar\|cambios" "$DIR/respuesta.txt" || { echo "No menciona revisar diffs"; exit 1; }
echo "OK"
