#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/app.js" ] || { echo "Falta app.js"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "condicional\|conditional" "$DIR/respuesta.txt" || { echo "No menciona condicional"; exit 1; }
echo "OK"
