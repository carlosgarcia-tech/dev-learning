#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "lockfile\|lock\|exact\|estrict" "$DIR/respuesta.txt" || { echo "La respuesta no menciona el lockfile"; exit 1; }
echo "OK"
