#!/bin/bash
# Crea main con 2 commits y feature/docs con 1 commit (fast-forward posible).
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"
echo 'console.log("app");' > app.js
git add app.js
git commit -q -m "feat: añade app"

# Rama feature/docs desde main
git switch -c feature/docs
echo "# Documentación" > docs.md
git add docs.md
git commit -q -m "docs: añade docs.md"

# Volver a main para que el estudiante haga el merge
git switch main

echo "$REPO_DIR"
