#!/bin/bash
# Valida: existe vendor/lib como submodule, .gitmodules correcto, commiteado, lib.txt accesible.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

OUTPUT=$(bash "$SCRIPT_DIR/setup.sh")
MAIN=$(echo "$OUTPUT" | sed -n '1p')
LIB=$(echo "$OUTPUT" | sed -n '2p')
TMP_DIR="$(dirname "$MAIN")"
trap 'rm -rf "$TMP_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$MAIN" "$LIB"

# 1. vendor/lib existe
if [ ! -d "$MAIN/vendor/lib" ]; then
    echo "FAIL Tests fallaron"; echo "  No existe vendor/lib"; exit 1
fi

# 2. .gitmodules existe y referencia la ruta correcta
if [ ! -f "$MAIN/.gitmodules" ]; then
    echo "FAIL Tests fallaron"; echo "  No existe .gitmodules"; exit 1
fi
if ! grep -q "vendor/lib" "$MAIN/.gitmodules"; then
    echo "FAIL Tests fallaron"; echo "  .gitmodules no referencia vendor/lib"; exit 1
fi

# 3. lib.txt es accesible
if [ ! -f "$MAIN/vendor/lib/lib.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  vendor/lib/lib.txt no es accesible"; exit 1
fi

# 4. .gitmodules está commiteado con el mensaje correcto
MSG=$(git -C "$MAIN" log -1 --format="%s")
if [ "$MSG" != "chore: añade lib como submodule" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'chore: añade lib como submodule', obtenido '$MSG'"; exit 1
fi

# 5. git submodule status muestra vendor/lib
if ! git -C "$MAIN" submodule status | grep -q "vendor/lib"; then
    echo "FAIL Tests fallaron"; echo "  git submodule status no muestra vendor/lib"; exit 1
fi

echo "OK Tests pasaron"
