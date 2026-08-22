#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/script.sh" ] || { echo "Falta script.sh"; exit 1; }
[ -x "$DIR/script.sh" ] || { echo "script.sh no es ejecutable"; exit 1; }
echo "OK"
