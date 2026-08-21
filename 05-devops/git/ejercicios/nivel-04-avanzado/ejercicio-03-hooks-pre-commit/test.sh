#!/bin/bash
# Valida: hook existe y es ejecutable, hooksPath configurado, secrets.env no commiteado, commit permitido existe.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. El hook existe y es ejecutable
if [ ! -x "$REPO_DIR/.githooks/pre-commit" ]; then
    echo "FAIL Tests fallaron"; echo "  .githooks/pre-commit no existe o no es ejecutable"; exit 1
fi

# 2. hooksPath configurado a .githooks
HP=$(git -C "$REPO_DIR" config core.hooksPath)
if [ "$HP" != ".githooks" ]; then
    echo "FAIL Tests fallaron"; echo "  core.hooksPath esperado '.githooks', obtenido '$HP'"; exit 1
fi

# 3. El hook bloquea secrets.env (probar directamente)
echo "test=1" > "$REPO_DIR/secrets.env"
git -C "$REPO_DIR" add secrets.env
if git -C "$REPO_DIR" commit -m "test" 2>/dev/null; then
    echo "FAIL Tests fallaron"; echo "  El hook NO bloqueó el commit de secrets.env"; exit 1
fi
git -C "$REPO_DIR" restore --staged secrets.env
rm -f "$REPO_DIR/secrets.env"

# 4. secrets.env no está commiteado en el historial
if git -C "$REPO_DIR" ls-tree -r HEAD --name-only | grep -q "secrets.env"; then
    echo "FAIL Tests fallaron"; echo "  secrets.env está commiteado (no debería)"; exit 1
fi

# 5. Existe un commit con mensaje 'feat: commit permitido'
if ! git -C "$REPO_DIR" log --oneline | grep -q "feat: commit permitido"; then
    echo "FAIL Tests fallaron"; echo "  No existe el commit 'feat: commit permitido'"; exit 1
fi

echo "OK Tests pasaron"
