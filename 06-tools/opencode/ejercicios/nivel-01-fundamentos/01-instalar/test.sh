#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "install" "$DIR/respuesta.txt" || { echo "No menciona install"; exit 1; }
grep -qi "version" "$DIR/respuesta.txt" || { echo "No menciona version"; exit 1; }
echo "OK"
