#!/bin/bash
# Crea un repo en main con 2 commits.
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

echo "$REPO_DIR"
