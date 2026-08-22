#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "nohup\|sobreviv\|SIGHUP" "$DIR/respuesta.txt" || { echo "No explica nohup"; exit 1; }
echo "OK"
