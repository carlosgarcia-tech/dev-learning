#!/bin/bash
# Crea un repo con 2 commits.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q
echo "# Mi proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"
echo 'console.log("hola");' > app.js
git add app.js
git commit -q -m "feat: añade app.js"

echo "$REPO_DIR"
