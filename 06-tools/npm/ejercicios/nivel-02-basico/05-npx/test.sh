#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/salida.txt" ] || { echo "Falta salida.txt"; exit 1; }
grep -qi "hola npm" "$DIR/salida.txt" || { echo "El contenido no es el esperado"; exit 1; }
! node -p "require('./$DIR/package.json').dependencies.cowsay" 2>/dev/null | grep -q cowsay || { echo "cowsay no debería estar en dependencies"; exit 1; }
echo "OK"
