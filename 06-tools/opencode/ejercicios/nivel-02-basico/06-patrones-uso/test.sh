#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "bueno\|sí\|conviene" "$DIR/respuesta.txt" || { echo "No menciona casos buenos"; exit 1; }
grep -qi "no conviene\|no" "$DIR/respuesta.txt" || { echo "No menciona casos malos"; exit 1; }
echo "OK"
