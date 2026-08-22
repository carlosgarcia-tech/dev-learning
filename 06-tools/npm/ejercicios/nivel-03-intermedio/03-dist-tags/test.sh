#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "tag\|dist" "$DIR/respuesta.txt" || { echo "No menciona tag"; exit 1; }
grep -qi "@beta\|install.*beta" "$DIR/respuesta.txt" || { echo "No menciona cómo instalar beta"; exit 1; }
echo "OK"
