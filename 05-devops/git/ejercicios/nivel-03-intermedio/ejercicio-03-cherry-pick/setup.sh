#!/bin/bash
# Crea main y feature. En feature hay un commit con hotfix.js y otro con docs.md.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"

git switch -c feature
echo "# Docs" > docs.md
git add docs.md
git commit -q -m "docs: añade docs"
echo "function hotfix() {}" > hotfix.js
git add hotfix.js
git commit -q -m "fix: corrige bug crítico"

git switch main

echo "$REPO_DIR"
