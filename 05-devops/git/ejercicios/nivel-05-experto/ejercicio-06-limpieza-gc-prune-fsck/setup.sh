#!/bin/bash
# Crea main con varios commits y objetos sueltos (sin gc previo).
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"
echo "a" > a.txt
git add a.txt
git commit -q -m "feat: añade a"
echo "b" > b.txt
git add b.txt
git commit -q -m "feat: añade b"
# Crear objetos sueltos adicionales sin gc
git -c gc.auto=0 commit --allow-empty -q -m "chore: commit vacío"

echo "$REPO_DIR"
