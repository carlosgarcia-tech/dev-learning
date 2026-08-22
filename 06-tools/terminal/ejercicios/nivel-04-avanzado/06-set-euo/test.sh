#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/robusto.sh" ] || { echo "Falta robusto.sh"; exit 1; }
grep -q "set -euo pipefail" "$DIR/robusto.sh" || { echo "Falta set -euo pipefail"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "\-e:" "$DIR/respuesta.txt" || { echo "No explica -e"; exit 1; }
grep -qi "\-u:" "$DIR/respuesta.txt" || { echo "No explica -u"; exit 1; }
echo "OK"
