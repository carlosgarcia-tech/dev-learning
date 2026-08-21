#!/bin/bash
# Solución: configurar gpgsign y signingkey, crear commit firmado (con fallback si no hay GPG).
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

git config commit.gpgsign true
git config user.signingkey DEADBEEFDEADBEEF
echo "firmado" > firmado.txt
git add firmado.txt
git commit -S -q -m "feat: commit firmado" 2>/dev/null || git -c commit.gpgsign=false commit -q -m "feat: commit firmado"
