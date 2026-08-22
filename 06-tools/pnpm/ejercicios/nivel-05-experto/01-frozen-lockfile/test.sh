#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "frozen\|lockfile" "$DIR/respuesta.txt" || { echo "No menciona frozen/lockfile"; exit 1; }
grep -qi "ci\|reproducib" "$DIR/respuesta.txt" || { echo "No menciona CI/reproducibilidad"; exit 1; }
echo "OK"
