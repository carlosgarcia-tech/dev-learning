#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "SIGTERM\|TERM" "$DIR/respuesta.txt" || { echo "No menciona SIGTERM"; exit 1; }
grep -qi "SIGKILL\|kill -9" "$DIR/respuesta.txt" || { echo "No menciona SIGKILL"; exit 1; }
echo "OK"
