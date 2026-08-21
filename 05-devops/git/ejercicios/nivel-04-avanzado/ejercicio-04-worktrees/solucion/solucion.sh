#!/bin/bash
# Solución: crear worktree para feature, añadir y commitear feature.txt.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git worktree add -q ../wt-feature feature
cd ../wt-feature
echo "feature content" > feature.txt
git add feature.txt
git commit -q -m "feat: añade feature.txt"
