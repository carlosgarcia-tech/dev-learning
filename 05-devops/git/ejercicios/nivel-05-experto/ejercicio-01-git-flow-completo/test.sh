#!/bin/bash
# Valida: ramas existen, main y develop tienen los archivos correctos, tag anotado v1.0.1.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

BRANCHES=$(git -C "$REPO_DIR" branch --format="%(refname:short)")

check_branch() {
    if ! echo "$BRANCHES" | grep -qx "$1"; then
        echo "FAIL Tests fallaron"; echo "  No existe la rama $1"; exit 1
    fi
}

# 1. Existen todas las ramas
for b in main develop feature/login release/1.0.0 hotfix/1.0.1; do
    check_branch "$b"
done

# 2. main contiene login.js (con el fix), CHANGELOG.md
if ! git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "login.js"; then
    echo "FAIL Tests fallaron"; echo "  main no contiene login.js"; exit 1
fi
if ! git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "CHANGELOG.md"; then
    echo "FAIL Tests fallaron"; echo "  main no contiene CHANGELOG.md"; exit 1
fi

# 3. login.js en main contiene "fix" (del hotfix)
if ! git -C "$REPO_DIR" show main:login.js | grep -q "fix"; then
    echo "FAIL Tests fallaron"; echo "  login.js en main no contiene el fix del hotfix"; exit 1
fi

# 4. develop también tiene el hotfix (login.js con "fix")
if ! git -C "$REPO_DIR" show develop:login.js | grep -q "fix"; then
    echo "FAIL Tests fallaron"; echo "  develop no tiene el fix del hotfix"; exit 1
fi

# 5. develop tiene CHANGELOG.md
if ! git -C "$REPO_DIR" ls-tree -r develop --name-only | grep -qx "CHANGELOG.md"; then
    echo "FAIL Tests fallaron"; echo "  develop no contiene CHANGELOG.md"; exit 1
fi

# 6. Tag anotado v1.0.1 con mensaje correcto
if ! git -C "$REPO_DIR" rev-parse -q --verify "refs/tags/v1.0.1" >/dev/null; then
    echo "FAIL Tests fallaron"; echo "  No existe el tag v1.0.1"; exit 1
fi
TYPE=$(git -C "$REPO_DIR" cat-file -t v1.0.1)
if [ "$TYPE" != "tag" ]; then
    echo "FAIL Tests fallaron"; echo "  v1.0.1 debería ser anotado (tipo 'tag'), es '$TYPE'"; exit 1
fi
TAG_MSG=$(git -C "$REPO_DIR" for-each-ref refs/tags/v1.0.1 --format="%(contents:subject)")
if [ "$TAG_MSG" != "Release 1.0.1" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje del tag esperado 'Release 1.0.1', obtenido '$TAG_MSG'"; exit 1
fi

echo "OK Tests pasaron"
