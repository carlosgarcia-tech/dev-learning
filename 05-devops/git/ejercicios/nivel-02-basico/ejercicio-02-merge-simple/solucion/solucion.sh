#!/bin/bash
# Solución: fusionar feature/docs en main (fast-forward).
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git switch main
git merge feature/docs
