#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "interactiv\|TUI" "$DIR/respuesta.txt" || { echo "No menciona interactivo"; exit 1; }
grep -qi "headless\|run\|CI" "$DIR/respuesta.txt" || { echo "No menciona headless"; exit 1; }
echo "OK"
