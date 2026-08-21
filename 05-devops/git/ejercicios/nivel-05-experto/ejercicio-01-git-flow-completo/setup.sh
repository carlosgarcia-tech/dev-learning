#!/bin/bash
# Crea main con un commit inicial.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"

echo "$REPO_DIR"
