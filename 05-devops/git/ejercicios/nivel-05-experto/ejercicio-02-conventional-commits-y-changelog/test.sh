#!/bin/bash
# Valida: 4 commits con mensajes exactos, CHANGELOG.md commiteado y con secciones correctas.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Los 4 commits existen con mensajes exactos
for msg in "feat: añade página de inicio" "fix: corrige error de login" "docs: actualiza README" "feat!: cambia API de autenticación"; do
    if ! git -C "$REPO_DIR" log --oneline | grep -qF "$msg"; then
        echo "FAIL Tests fallaron"; echo "  Falta el commit: $msg"; exit 1
    fi
done

# 2. CHANGELOG.md commiteado
if ! git -C "$REPO_DIR" ls-files --error-unmatch CHANGELOG.md >/dev/null 2>&1; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no está commiteado"; exit 1
fi

# 3. Sección Features con "añade página de inicio"
CL=$(cat "$REPO_DIR/CHANGELOG.md")
if ! echo "$CL" | grep -qi "Features"; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no tiene sección Features"; exit 1
fi
if ! echo "$CL" | grep -qF "añade página de inicio"; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no menciona 'añade página de inicio'"; exit 1
fi

# 4. Sección Bug Fixes con "corrige error de login"
if ! echo "$CL" | grep -qi "Bug Fixes"; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no tiene sección Bug Fixes"; exit 1
fi
if ! echo "$CL" | grep -qF "corrige error de login"; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no menciona 'corrige error de login'"; exit 1
fi

# 5. Breaking change mencionado
if ! echo "$CL" | grep -qi "BREAKING"; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no menciona BREAKING CHANGES"; exit 1
fi
if ! echo "$CL" | grep -qF "cambia API de autenticación"; then
    echo "FAIL Tests fallaron"; echo "  CHANGELOG.md no menciona 'cambia API de autenticación'"; exit 1
fi

echo "OK Tests pasaron"
