#!/bin/bash
# Solución: fusionar feature, resolver conflicto a favor de feature, completar merge.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git switch main
git merge feature || true
# Resolver el conflicto dejando la versión de feature
printf "Línea feature\n" > README.md
git add README.md
git commit -q -m "merge: integra feature"
