#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Step Over\|F10" "$DIR/respuesta.txt" || { echo "No menciona Step Over"; exit 1; }
grep -qi "Step Into\|F11" "$DIR/respuesta.txt" || { echo "No menciona Step Into"; exit 1; }
echo "OK"
