#!/bin/bash
# Valida el proyecto final: Git Flow, hooks, conventional commits, changelog, tags, remote, CI.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

OUTPUT=$(bash "$SCRIPT_DIR/setup.sh")
REPO=$(echo "$OUTPUT" | sed -n '1p')
REMOTE=$(echo "$OUTPUT" | sed -n '2p')
TMP_DIR="$(dirname "$REPO")"
trap 'rm -rf "$TMP_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO" "$REMOTE"

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

# 1. Ramas de Git Flow existen
for b in main develop feature/auth release/1.0.0 hotfix/1.0.1; do
    if ! git -C "$REPO" branch --format="%(refname:short)" | grep -qx "$b"; then
        fail "No existe la rama $b"
    fi
done

# 2. main contiene app/auth.js y CHANGELOG.md
git -C "$REPO" ls-tree -r main --name-only | grep -qx "app/auth.js" || fail "main no contiene app/auth.js"
git -C "$REPO" ls-tree -r main --name-only | grep -qx "CHANGELOG.md" || fail "main no contiene CHANGELOG.md"

# 3. Historial de main contiene feat:, fix:, docs:
git -C "$REPO" log main --format="%s" | grep -q "^feat" || fail "main no tiene commits feat:"
git -C "$REPO" log main --format="%s" | grep -q "^fix" || fail "main no tiene commits fix:"
git -C "$REPO" log main --format="%s" | grep -q "^docs" || fail "main no tiene commits docs:"

# 4. CHANGELOG.md tiene secciones Features y Bug Fixes
CL=$(cat "$REPO/CHANGELOG.md")
echo "$CL" | grep -qi "Features" || fail "CHANGELOG.md no tiene sección Features"
echo "$CL" | grep -qi "Bug Fixes" || fail "CHANGELOG.md no tiene sección Bug Fixes"

# 5. Tags anotados v1.0.0 y v1.0.1 con mensajes
for t in v1.0.0 v1.0.1; do
    if ! git -C "$REPO" rev-parse -q --verify "refs/tags/$t" >/dev/null; then
        fail "No existe el tag $t"
    fi
    [ "$(git -C "$REPO" cat-file -t "$t")" = "tag" ] || fail "$t no es tag anotado"
done

# 6. Remote tiene main, develop y los tags
[ "$(git --git-dir="$REMOTE" rev-parse main)" = "$(git -C "$REPO" rev-parse main)" ] || fail "remote/main no coincide"
[ "$(git --git-dir="$REMOTE" rev-parse develop)" = "$(git -C "$REPO" rev-parse develop)" ] || fail "remote/develop no coincide"
git --git-dir="$REMOTE" tag -l v1.0.0 | grep -q v1.0.0 || fail "remote no tiene tag v1.0.0"
git --git-dir="$REMOTE" tag -l v1.0.1 | grep -q v1.0.1 || fail "remote no tiene tag v1.0.1"

# 7. Hook pre-commit bloquea *.env
echo "SECRET=1" > "$REPO/secrets.env"
git -C "$REPO" add secrets.env
if git -C "$REPO" commit -m "test" 2>/dev/null; then
    fail "El hook pre-commit no bloqueó secrets.env"
fi
git -C "$REPO" restore --staged secrets.env 2>/dev/null || true
rm -f "$REPO/secrets.env"

# 8. Hook commit-msg valida Conventional Commits
echo "contenido" > "$REPO/app/test.js"
git -C "$REPO" add app/test.js
if git -C "$REPO" commit -m "mensaje invalido" 2>/dev/null; then
    fail "El hook commit-msg no bloqueó un mensaje inválido"
fi
git -C "$REPO" restore --staged app/test.js 2>/dev/null || true
rm -f "$REPO/app/test.js"

# 9. CI pasa
if ! bash "$REPO/ci.sh" >/dev/null 2>&1; then
    fail "ci.sh no pasa"
fi

# 10. develop tiene el hotfix (auth.js + main.js corregido)
git -C "$REPO" ls-tree -r develop --name-only | grep -qx "app/auth.js" || fail "develop no tiene app/auth.js"

echo "OK Tests pasaron"
