#!/bin/bash
# Crea 6 commits en bug.txt; uno de ellos (el 3º) introduce la línea BUG.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "línea 1" > bug.txt
git add bug.txt
git commit -q -m "c1: añade línea 1"
echo "línea 2" >> bug.txt
git commit -q -am "c2: añade línea 2"
echo "BUG" >> bug.txt
git commit -q -am "c3: introduce bug"
echo "línea 4" >> bug.txt
git commit -q -am "c4: añade línea 4"
echo "línea 5" >> bug.txt
git commit -q -am "c5: añade línea 5"
echo "línea 6" >> bug.txt
git commit -q -am "c6: añade línea 6"

echo "$REPO_DIR"
