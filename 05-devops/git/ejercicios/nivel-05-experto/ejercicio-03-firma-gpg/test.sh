#!/bin/bash
# Valida: gpgsign=true, signingkey configurado, commit con mensaje correcto existe.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. commit.gpgsign = true
GPGSIGN=$(git -C "$REPO_DIR" config commit.gpgsign)
if [ "$GPGSIGN" != "true" ]; then
    echo "FAIL Tests fallaron"; echo "  commit.gpgsign esperado 'true', obtenido '$GPGSIGN'"; exit 1
fi

# 2. user.signingkey tiene un valor
SIGNKEY=$(git -C "$REPO_DIR" config user.signingkey)
if [ -z "$SIGNKEY" ]; then
    echo "FAIL Tests fallaron"; echo "  user.signingkey no está configurado"; exit 1
fi

# 3. Existe un commit con el mensaje correcto
if ! git -C "$REPO_DIR" log --oneline | grep -qF "feat: commit firmado"; then
    echo "FAIL Tests fallaron"; echo "  No existe el commit 'feat: commit firmado'"; exit 1
fi

# 4. firmado.txt está commiteado
if ! git -C "$REPO_DIR" ls-files --error-unmatch firmado.txt >/dev/null 2>&1; then
    echo "FAIL Tests fallaron"; echo "  firmado.txt no está commiteado"; exit 1
fi

echo "OK Tests pasaron"
