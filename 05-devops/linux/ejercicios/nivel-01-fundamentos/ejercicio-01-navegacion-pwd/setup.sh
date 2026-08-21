#!/usr/bin/env bash
# Crea un árbol de directorios de ejemplo en el directorio indicado ($1)
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/proyectos/web/src" "$DEST/proyectos/web/docs" "$DEST/proyectos/web/tests"
mkdir -p "$DEST/proyectos/api/src" "$DEST/proyectos/api/docs"
echo "# web" > "$DEST/proyectos/web/src/index.html"
echo "doc" > "$DEST/proyectos/web/docs/readme.txt"
echo "# api" > "$DEST/proyectos/api/src/main.py"
