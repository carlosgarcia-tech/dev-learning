#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/script.sh" ] || { echo "Falta script.sh"; exit 1; }
grep -q "NOMBRE=" "$DIR/script.sh" || { echo "Falta variable NOMBRE"; exit 1; }
grep -qE '\$\(' "$DIR/script.sh" || { echo "Falta sustitución de comandos"; exit 1; }
echo "OK"
