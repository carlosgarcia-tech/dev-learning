#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "<ul>" "$DIR/respuesta.txt" || { echo "Falta <ul>"; exit 1; }
grep -qi "<li>" "$DIR/respuesta.txt" || { echo "Falta <li>"; exit 1; }
grep -qi "Item 1" "$DIR/respuesta.txt" || { echo "Falta Item 1"; exit 1; }
echo "OK"
