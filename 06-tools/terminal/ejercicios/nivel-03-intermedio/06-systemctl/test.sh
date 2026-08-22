#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "systemctl status" "$DIR/respuesta.txt" || { echo "No menciona status"; exit 1; }
grep -qi "restart" "$DIR/respuesta.txt" || { echo "No menciona restart"; exit 1; }
echo "OK"
