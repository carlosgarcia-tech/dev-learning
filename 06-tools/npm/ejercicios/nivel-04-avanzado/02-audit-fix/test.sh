#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "audit fix" "$DIR/respuesta.txt" || { echo "No menciona audit fix"; exit 1; }
grep -qi "force" "$DIR/respuesta.txt" || { echo "No menciona --force"; exit 1; }
echo "OK"
