#!/bin/bash
# Solución: reconstruir el historial en orden inverso y renombrar el último mensaje.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

# Hashes de los 4 commits (del más antiguo al más reciente)
BASE=$(git rev-parse HEAD~4)
# Reconstruir aplicando en orden inverso
git reset --hard "$BASE"
# Recuperar los hashes originales desde el reflog de HEAD
H1=$(git reflog | grep -m1 "wip 1" | awk '{print $1}')
H2=$(git reflog | grep -m1 "wip 2" | awk '{print $1}')
H3=$(git reflog | grep -m1 "wip 3" | awk '{print $1}')
H4=$(git reflog | grep -m1 "wip 4" | awk '{print $1}')
git cherry-pick "$H4" "$H3" "$H2" "$H1"
git commit --amend -q -m "feat: commit final"
