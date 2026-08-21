#!/bin/bash
# Solución: inicializar el repo y crear el primer commit.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git init -q
git add README.md
git commit -q -m "Commit inicial"
