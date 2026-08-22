#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "logpoint" "$DIR/respuesta.txt" || { echo "No menciona logpoint"; exit 1; }
grep -qi "pausa\|imprim" "$DIR/respuesta.txt" || { echo "No explica diferencia"; exit 1; }
echo "OK"
