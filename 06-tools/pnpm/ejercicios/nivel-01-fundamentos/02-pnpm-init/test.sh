#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
NAME=$(node -p "require('./$DIR/package.json').name || ''")
[ "$NAME" = "mi-app" ] || { echo "name incorrecto: $NAME"; exit 1; }
echo "OK"
