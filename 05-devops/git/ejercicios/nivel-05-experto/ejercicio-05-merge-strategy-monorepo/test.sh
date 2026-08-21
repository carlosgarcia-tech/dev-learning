#!/bin/bash
# Valida: main tiene v2.js y handler.js v2; apps/web intacto; CODEOWNERS commiteado.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. main contiene apps/api/v2.js
if ! git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "apps/api/v2.js"; then
    echo "FAIL Tests fallaron"; echo "  main no contiene apps/api/v2.js (merge no integrado)"; exit 1
fi

# 2. handler.js en main tiene el contenido v2
HANDLER=$(git -C "$REPO_DIR" show main:apps/api/handler.js)
if [ "$HANDLER" != "v2" ]; then
    echo "FAIL Tests fallaron"; echo "  apps/api/handler.js en main esperado 'v2', obtenido '$HANDLER'"; exit 1
fi

# 3. apps/web/index.html sigue intacto (no modificado por el merge)
WEB=$(git -C "$REPO_DIR" show main:apps/web/index.html)
if [ "$WEB" != "web" ]; then
    echo "FAIL Tests fallaron"; echo "  apps/web/index.html fue modificado por el merge (no debería)"; exit 1
fi

# 4. CODEOWNERS existe y commiteado
if [ ! -f "$REPO_DIR/.github/CODEOWNERS" ]; then
    echo "FAIL Tests fallaron"; echo "  No existe .github/CODEOWNERS"; exit 1
fi
if ! git -C "$REPO_DIR" ls-files --error-unmatch .github/CODEOWNERS >/dev/null 2>&1; then
    echo "FAIL Tests fallaron"; echo "  .github/CODEOWNERS no está commiteado"; exit 1
fi

# 5. CODEOWNERS contiene las asignaciones correctas
CO=$(cat "$REPO_DIR/.github/CODEOWNERS")
if ! echo "$CO" | grep -q "/apps/web/.*@equipo-frontend"; then
    echo "FAIL Tests fallaron"; echo "  CODEOWNERS no asigna apps/web a @equipo-frontend"; exit 1
fi
if ! echo "$CO" | grep -q "/apps/api/.*@equipo-backend"; then
    echo "FAIL Tests fallaron"; echo "  CODEOWNERS no asigna apps/api a @equipo-backend"; exit 1
fi

echo "OK Tests pasaron"
