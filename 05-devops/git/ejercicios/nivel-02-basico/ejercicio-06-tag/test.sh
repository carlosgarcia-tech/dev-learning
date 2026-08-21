#!/bin/bash
# Valida: existe v1.0.0 anotado con mensaje, existe v1.0.1 ligero.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Existe v1.0.0
if ! git -C "$REPO_DIR" rev-parse -q --verify "refs/tags/v1.0.0" >/dev/null; then
    echo "FAIL Tests fallaron"; echo "  No existe el tag v1.0.0"; exit 1
fi

# 2. v1.0.0 es anotado (objeto tag)
TYPE=$(git -C "$REPO_DIR" cat-file -t v1.0.0)
if [ "$TYPE" != "tag" ]; then
    echo "FAIL Tests fallaron"; echo "  v1.0.0 debería ser anotado (tipo 'tag'), es '$TYPE'"; exit 1
fi

# 3. Mensaje del tag anotado
TAG_MSG=$(git -C "$REPO_DIR" for-each-ref refs/tags/v1.0.0 --format="%(contents:subject)")
if [ "$TAG_MSG" != "Release 1.0.0" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje del tag esperado 'Release 1.0.0', obtenido '$TAG_MSG'"; exit 1
fi

# 4. Existe v1.0.1
if ! git -C "$REPO_DIR" rev-parse -q --verify "refs/tags/v1.0.1" >/dev/null; then
    echo "FAIL Tests fallaron"; echo "  No existe el tag v1.0.1"; exit 1
fi

# 5. v1.0.1 es ligero (apunta a un commit, no a un objeto tag)
TYPE2=$(git -C "$REPO_DIR" cat-file -t v1.0.1)
if [ "$TYPE2" != "commit" ]; then
    echo "FAIL Tests fallaron"; echo "  v1.0.1 debería ser ligero (tipo 'commit'), es '$TYPE2'"; exit 1
fi

echo "OK Tests pasaron"
