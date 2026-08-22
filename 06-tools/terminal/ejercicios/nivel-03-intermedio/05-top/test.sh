#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "CPU\|memoria" "$DIR/respuesta.txt" || { echo "No menciona CPU/memoria"; exit 1; }
grep -qi "load average" "$DIR/respuesta.txt" || { echo "No menciona load average"; exit 1; }
echo "OK"
