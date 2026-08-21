#!/bin/bash
# Solución: hacer squash de los 3 commits WIP en uno solo.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git reset --soft HEAD~3
git commit -q -m "feat: completa documentación"
