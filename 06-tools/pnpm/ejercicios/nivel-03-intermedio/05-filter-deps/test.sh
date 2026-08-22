#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "dependientes\|dependencias" "$DIR/respuesta.txt" || { echo "No menciona dependientes/dependencias"; exit 1; }
echo "OK"
