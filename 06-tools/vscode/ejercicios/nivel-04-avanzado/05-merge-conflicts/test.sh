#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Current\|Incoming\|Both" "$DIR/respuesta.txt" || { echo "No menciona opciones"; exit 1; }
echo "OK"
