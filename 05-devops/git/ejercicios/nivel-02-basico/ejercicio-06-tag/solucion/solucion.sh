#!/bin/bash
# Solución: crear tag anotado v1.0.0 y tag ligero v1.0.1.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git tag -a v1.0.0 -m "Release 1.0.0"
git tag v1.0.1
