#!/bin/bash
# Crea feature con 4 commits wip encima del inicial.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b feature
echo "base" > file.txt
git add file.txt
git commit -q -m "Commit inicial"
# Cada commit crea un archivo INDEPENDIENTE para que el cherry-pick no genere conflictos
echo "1" > wip1.txt; git add wip1.txt; git commit -q -m "wip 1"
echo "2" > wip2.txt; git add wip2.txt; git commit -q -m "wip 2"
echo "3" > wip3.txt; git add wip3.txt; git commit -q -m "wip 3"
echo "4" > wip4.txt; git add wip4.txt; git commit -q -m "wip 4"

echo "$REPO_DIR"
