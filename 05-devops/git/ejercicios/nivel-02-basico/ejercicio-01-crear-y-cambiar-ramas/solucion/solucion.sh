#!/bin/bash
# Solución: crear rama, commitear login, volver a main y commitear home.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git switch -c feature/login
echo "function login() {}" > login.js
git add login.js
git commit -q -m "feat: añade login"

git switch main
echo "function home() {}" > home.js
git add home.js
git commit -q -m "feat: añade home"
