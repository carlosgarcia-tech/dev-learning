#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/log.txt" ] || { echo "Falta log.txt"; exit 1; }
[ -f "$DIR/errores.txt" ] || { echo "Falta errores.txt"; exit 1; }
[ -f "$DIR/conteo.txt" ] || { echo "Falta conteo.txt"; exit 1; }
grep -q "ERROR" "$DIR/errores.txt" || { echo "errores.txt no contiene ERROR"; exit 1; }
echo "OK"
