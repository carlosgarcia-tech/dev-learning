#!/usr/bin/env bash
# Verifica que el ejercicio 01-inicializar-proyecto está resuelto.
set -euo pipefail

DIR="solucion"
[ -f "$DIR/package.json" ] || { echo "Falta package.json"; exit 1; }
[ -f "$DIR/index.js" ] || { echo "Falta index.js"; exit 1; }

NAME=$(node -p "require('./$DIR/package.json').name")
[ "$NAME" = "mi-proyecto" ] || { echo "name incorrecto: $NAME"; exit 1; }

node -p "require('./$DIR/package.json').scripts.start" | grep -q "node index.js" || { echo "Falta script start"; exit 1; }
echo "OK"
