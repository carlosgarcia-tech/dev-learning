#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "auth login" "$DIR/respuesta.txt" || { echo "No menciona auth login"; exit 1; }
grep -qi "whoami\|auth status" "$DIR/respuesta.txt" || { echo "No menciona verificación"; exit 1; }
echo "OK"
