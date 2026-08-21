#!/bin/bash
# Valida: existe feature/login, login.js commiteado, home.js en main, ramas divergen.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Existe la rama feature/login
if ! git -C "$REPO_DIR" branch --list feature/login | grep -q "feature/login"; then
    echo "FAIL Tests fallaron"; echo "  No existe la rama feature/login"; exit 1
fi

# 2. login.js commiteado en feature/login con mensaje correcto
if ! git -C "$REPO_DIR" ls-tree -r feature/login --name-only | grep -qx "login.js"; then
    echo "FAIL Tests fallaron"; echo "  login.js no está en feature/login"; exit 1
fi
LOGIN_MSG=$(git -C "$REPO_DIR" log feature/login -1 --format="%s")
if [ "$LOGIN_MSG" != "feat: añade login" ]; then
    echo "FAIL Tests fallaron"; echo "  Último commit de feature/login esperado 'feat: añade login', obtenido '$LOGIN_MSG'"; exit 1
fi

# 3. home.js commiteado en main con mensaje correcto
if ! git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "home.js"; then
    echo "FAIL Tests fallaron"; echo "  home.js no está en main"; exit 1
fi
HOME_MSG=$(git -C "$REPO_DIR" log main -1 --format="%s")
if [ "$HOME_MSG" != "feat: añade home" ]; then
    echo "FAIL Tests fallaron"; echo "  Último commit de main esperado 'feat: añade home', obtenido '$HOME_MSG'"; exit 1
fi

# 4. Las ramas divergen (últimos commits distintos)
MAIN_TIP=$(git -C "$REPO_DIR" rev-parse main)
FEAT_TIP=$(git -C "$REPO_DIR" rev-parse feature/login)
if [ "$MAIN_TIP" = "$FEAT_TIP" ]; then
    echo "FAIL Tests fallaron"; echo "  main y feature/login apuntan al mismo commit (no divergen)"; exit 1
fi

echo "OK Tests pasaron"
