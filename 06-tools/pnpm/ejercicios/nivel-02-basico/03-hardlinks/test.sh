#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "hardlink" "$DIR/respuesta.txt" || { echo "No menciona hardlink"; exit 1; }
echo "OK"
