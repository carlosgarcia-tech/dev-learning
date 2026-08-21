#!/bin/bash
# Crea un remoto bare y un clon de trabajo. Imprime la ruta del clon.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

TMP=$(mktemp -d)
REMOTE="$TMP/remote.git"
CLON="$TMP/clon"

# 1. Crear remoto bare con un commit inicial
git init -q --bare "$REMOTE"
WORK="$TMP/_seed"
git init -q -b main "$WORK"
cd "$WORK"
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"
git remote add origin "$REMOTE"
git push -q origin main
rm -rf "$WORK"

# 2. Clonar para el estudiante
git clone -q "$REMOTE" "$CLON"

echo "$CLON"
