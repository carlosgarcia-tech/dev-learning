#!/bin/bash
# Solución: rebasar feature sobre main para historia lineal.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git switch feature
git rebase main
