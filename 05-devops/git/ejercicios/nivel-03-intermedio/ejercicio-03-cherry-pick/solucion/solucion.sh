#!/bin/bash
# Solución: cherry-pick del commit que añade hotfix.js desde feature a main.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git switch main
HASH=$(git log feature --oneline -- hotfix.js | head -1 | awk '{print $1}')
git cherry-pick "$HASH"
