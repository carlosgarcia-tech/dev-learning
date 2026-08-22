#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "confusion\|supply" "$DIR/respuesta.txt" || { echo "No menciona confusion/supply"; exit 1; }
grep -qi "scope\|registry\|privado" "$DIR/respuesta.txt" || { echo "No menciona prevención"; exit 1; }
echo "OK"
