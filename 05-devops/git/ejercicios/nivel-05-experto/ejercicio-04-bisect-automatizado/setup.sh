#!/bin/bash
# Crea 8 commits; el 5º introduce BUG en app.txt.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "1" > app.txt
git add app.txt
git commit -q -m "c1"
echo "2" >> app.txt
git commit -q -am "c2"
echo "3" >> app.txt
git commit -q -am "c3"
echo "4" >> app.txt
git commit -q -am "c4"
echo "BUG" >> app.txt
git commit -q -am "c5: introduce bug"
echo "6" >> app.txt
git commit -q -am "c6"
echo "7" >> app.txt
git commit -q -am "c7"
echo "8" >> app.txt
git commit -q -am "c8"

echo "$REPO_DIR"
