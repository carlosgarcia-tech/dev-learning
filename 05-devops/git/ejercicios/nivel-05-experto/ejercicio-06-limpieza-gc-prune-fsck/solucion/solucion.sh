#!/bin/bash
# Solución: ejecutar gc con prune y fsck.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git gc --prune=now -q
git fsck --full >/dev/null 2>&1 || true
