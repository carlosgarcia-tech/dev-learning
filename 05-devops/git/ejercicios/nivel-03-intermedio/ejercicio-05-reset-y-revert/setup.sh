#!/bin/bash
# Crea main con 3 commits: inicial, a.txt y b.txt.
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
git commit -q -m "feat: añade a.txt"
echo "b" > b.txt
git add b.txt
git commit -q -m "feat: añade b.txt"

echo "$REPO_DIR"
