#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "ask" "$DIR/respuesta.txt" || { echo "No menciona ask"; exit 1; }
grep -qi "auto" "$DIR/respuesta.txt" || { echo "No menciona auto"; exit 1; }
grep -qi "yolo" "$DIR/respuesta.txt" || { echo "No menciona yolo"; exit 1; }
echo "OK"
