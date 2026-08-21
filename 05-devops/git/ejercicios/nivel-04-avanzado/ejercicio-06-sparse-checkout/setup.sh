#!/bin/bash
# Crea un origen con apps/web.txt, apps/api.txt y docs/leame.txt. Imprime su ruta.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

TMP=$(mktemp -d)
ORIGIN="$TMP/origen"
git init -q -b main "$ORIGIN"
cd "$ORIGIN"
mkdir -p apps docs
echo "web" > apps/web.txt
echo "api" > apps/api.txt
echo "doc" > docs/leame.txt
echo "# Repo" > README.md
git add .
git commit -q -m "Commit inicial"

echo "$ORIGIN"
