#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "install-extension" "$DIR/respuesta.txt" || { echo "No menciona install-extension"; exit 1; }
grep -qi "list-extensions" "$DIR/respuesta.txt" || { echo "No menciona list-extensions"; exit 1; }
echo "OK"
