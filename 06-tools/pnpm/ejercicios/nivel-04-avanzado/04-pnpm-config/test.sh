#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/registry.txt" ] || { echo "Falta registry.txt"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "project\|user" "$DIR/respuesta.txt" || { echo "Respuesta incompleta"; exit 1; }
echo "OK"
