#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "archivo\|raíz" "$DIR/respuesta.txt" || { echo "No menciona problema de archivos"; exit 1; }
grep -qi "auth\|autentic" "$DIR/respuesta.txt" || { echo "No menciona autenticación"; exit 1; }
echo "OK"
