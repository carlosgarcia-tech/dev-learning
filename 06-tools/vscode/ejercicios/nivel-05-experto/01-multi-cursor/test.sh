#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Alt+Click\|Ctrl+D\|Ctrl+Alt" "$DIR/respuesta.txt" || { echo "No menciona métodos"; exit 1; }
echo "OK"
