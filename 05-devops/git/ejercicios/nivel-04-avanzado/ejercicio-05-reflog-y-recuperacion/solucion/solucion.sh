#!/bin/bash
# Solución: reset hard 2 commits atrás y recuperar el commit feat: tercero desde el reflog.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git reset --hard HEAD~2
HASH=$(git reflog | grep -m1 "feat: tercero" | awk '{print $1}')
git reset --hard "$HASH"
