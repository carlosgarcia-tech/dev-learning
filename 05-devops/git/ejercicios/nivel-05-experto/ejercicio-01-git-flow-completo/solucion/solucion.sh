#!/bin/bash
# Solución: implementar Git Flow completo (develop, feature, release, hotfix, tag).
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# develop
git switch -c develop
# feature/login
git switch -c feature/login
echo "function login() {}" > login.js
git add login.js
git commit -q -m "feat: añade login"
git switch develop
git merge --no-ff feature/login -m "merge: integra feature/login"

# release/1.0.0
git switch -c release/1.0.0
echo "## 1.0.0" > CHANGELOG.md
git add CHANGELOG.md
git commit -q -m "chore: prepara release 1.0.0"
git switch main
git merge --no-ff release/1.0.0 -m "merge: integra release/1.0.0"
git switch develop
git merge --no-ff release/1.0.0 -m "merge: integra release/1.0.0 en develop"

# hotfix/1.0.1
git switch -c hotfix/1.0.1 main
echo "fix" >> login.js
git commit -q -am "fix: corrige bug en login"
git switch main
git merge --no-ff hotfix/1.0.1 -m "merge: integra hotfix/1.0.1"
git switch develop
git merge --no-ff hotfix/1.0.1 -m "merge: integra hotfix/1.0.1 en develop"

# tag
git switch main
git tag -a v1.0.1 -m "Release 1.0.1"
