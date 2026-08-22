#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "session list" "$DIR/respuesta.txt" || { echo "No menciona list"; exit 1; }
grep -qi "resume" "$DIR/respuesta.txt" || { echo "No menciona resume"; exit 1; }
echo "OK"
