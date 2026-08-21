#!/bin/bash
# Crea un repositorio "origen" con 1 commit y devuelve su ruta.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

TMP=$(mktemp -d)
ORIGIN_DIR="$TMP/origen"
git init -q "$ORIGIN_DIR"
cd "$ORIGIN_DIR"
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"

echo "$ORIGIN_DIR"
