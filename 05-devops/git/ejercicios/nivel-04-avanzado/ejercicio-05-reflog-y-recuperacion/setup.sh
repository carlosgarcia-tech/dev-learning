#!/bin/bash
# Crea main con 3 commits (inicial, feat: segundo, feat: tercero).
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "a" > a.txt
git add a.txt
git commit -q -m "Commit inicial"
echo "b" > b.txt
git add b.txt
git commit -q -m "feat: segundo"
echo "c" > c.txt
git add c.txt
git commit -q -m "feat: tercero"

echo "$REPO_DIR"
