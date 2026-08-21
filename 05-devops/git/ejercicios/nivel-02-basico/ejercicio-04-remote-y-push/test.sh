#!/bin/bash
# Valida: el clon tiene el commit y el remoto también (mismo tip en main).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

CLON_DIR=$(bash "$SCRIPT_DIR/setup.sh")
TMP_DIR="$(dirname "$CLON_DIR")"
REMOTE="$TMP_DIR/remote.git"
trap 'rm -rf "$TMP_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$CLON_DIR"

# 1. El clon tiene feature.js commiteado
if ! git -C "$CLON_DIR" ls-tree -r HEAD --name-only | grep -qx "feature.js"; then
    echo "FAIL Tests fallaron"; echo "  feature.js no está commiteado en el clon"; exit 1
fi

# 2. Mensaje correcto
MSG=$(git -C "$CLON_DIR" log -1 --format="%s")
if [ "$MSG" != "feat: añade feature.js" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'feat: añade feature.js', obtenido '$MSG'"; exit 1
fi

# 3. El remoto tiene el mismo commit (push exitoso)
LOCAL_TIP=$(git -C "$CLON_DIR" rev-parse HEAD)
REMOTE_TIP=$(git --git-dir="$REMOTE" rev-parse main)
if [ "$LOCAL_TIP" != "$REMOTE_TIP" ]; then
    echo "FAIL Tests fallaron"; echo "  El remoto no tiene el commit (push no realizado)"
    echo "  Local:  $LOCAL_TIP"
    echo "  Remoto: $REMOTE_TIP"
    exit 1
fi

echo "OK Tests pasaron"
