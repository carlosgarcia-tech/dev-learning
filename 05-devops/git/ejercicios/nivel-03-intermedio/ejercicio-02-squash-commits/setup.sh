#!/bin/bash
# Crea una rama feature con el commit inicial + 3 commits WIP.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b feature
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"

echo "## Intro" >> README.md
git commit -q -am "wip: intro"
echo "## Uso" >> README.md
git commit -q -am "wip: uso"
echo "## FAQ" >> README.md
git commit -q -am "wip: faq"

echo "$REPO_DIR"
