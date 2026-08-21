#!/bin/bash
# Crea un monorepo con apps/web, apps/api, packages/shared y una rama feature/api-v2.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
mkdir -p apps/web apps/api packages/shared
echo "web" > apps/web/index.html
echo "v1" > apps/api/handler.js
echo "shared" > packages/shared/util.js
echo "# Monorepo" > README.md
git add .
git commit -q -m "Commit inicial"

# feature/api-v2: reescribe handler y añade v2.js (solo toca apps/api)
git switch -c feature/api-v2
echo "v2" > apps/api/handler.js
echo "v2" > apps/api/v2.js
git add apps/api
git commit -q -m "feat(api): versión 2"

git switch main

echo "$REPO_DIR"
