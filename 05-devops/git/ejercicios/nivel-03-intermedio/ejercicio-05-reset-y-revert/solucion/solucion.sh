#!/bin/bash
# Solución: reset soft del último commit + revert del commit de a.txt.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# Parte A: deshacer el commit de b.txt dejando cambios en working tree
git reset --soft HEAD~1
git restore --staged b.txt

# Parte B: revertir el commit de a.txt sin reescribir historial
HASH_A=$(git log --oneline -- a.txt | head -1 | awk '{print $1}')
git revert --no-commit "$HASH_A"
git commit -q -m "revert: deshace a.txt"
