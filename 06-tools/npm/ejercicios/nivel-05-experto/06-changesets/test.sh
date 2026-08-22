#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "changeset" "$DIR/respuesta.txt" || { echo "No menciona changeset"; exit 1; }
grep -qi "publish" "$DIR/respuesta.txt" || { echo "No menciona publish"; exit 1; }
grep -qi "changelog" "$DIR/respuesta.txt" || { echo "No menciona changelog"; exit 1; }
echo "OK"
