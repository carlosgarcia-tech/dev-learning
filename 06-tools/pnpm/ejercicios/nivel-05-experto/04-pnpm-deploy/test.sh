#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "deploy\|extrae" "$DIR/respuesta.txt" || { echo "No explica deploy"; exit 1; }
echo "OK"
