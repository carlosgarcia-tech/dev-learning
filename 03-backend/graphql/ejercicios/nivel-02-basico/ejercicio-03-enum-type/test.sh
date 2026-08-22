#!/usr/bin/env bash
# test.sh — Ejercicio 03: Enum type
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 03 — Enum type"

# 1. enum PostStatus definido
if grep -qE 'enum[[:space:]]+PostStatus[[:space:]]*\{' "$SCHEMA"; then
  ok "enum PostStatus definido"
else
  fail "enum PostStatus no definido"
fi

# 2. Valores del enum
ENUM_OK=1
awk '/enum[[:space:]]+PostStatus[[:space:]]*\{/,/\}/' "$SCHEMA" | grep -qi 'DRAFT'     || ENUM_OK=0
awk '/enum[[:space:]]+PostStatus[[:space:]]*\{/,/\}/' "$SCHEMA" | grep -qi 'PUBLISHED' || ENUM_OK=0
awk '/enum[[:space:]]+PostStatus[[:space:]]*\{/,/\}/' "$SCHEMA" | grep -qi 'ARCHIVED'  || ENUM_OK=0
if [[ $ENUM_OK -eq 1 ]]; then
  ok "enum tiene DRAFT, PUBLISHED, ARCHIVED"
else
  fail "enum no tiene los tres valores"
fi

# 3. Post tiene status: PostStatus!
if grep -qE 'status:[[:space:]]*PostStatus!' "$SCHEMA"; then
  ok "Post.status: PostStatus! definido"
else
  fail "Post.status: PostStatus! no definido"
fi

# 4. Mutation updatePostStatus
if grep -qE 'updatePostStatus[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA" && \
   grep -qE 'updatePostStatus[[:space:]]*\([^)]*status:[[:space:]]*PostStatus!' "$SCHEMA"; then
  ok "updatePostStatus(id, status) definido"
else
  fail "updatePostStatus no definido correctamente"
fi

# 5. mutation usa PUBLISHED sin comillas
if grep -qE 'status:[[:space:]]*PUBLISHED' "$QUERY"; then
  ok "mutation usa status: PUBLISHED"
else
  fail "mutation no usa status: PUBLISHED"
fi

# 6. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d['data']['updatePostStatus']['status'] == 'PUBLISHED'
" 2>/dev/null; then
    ok "expected.json tiene status PUBLISHED"
  else
    fail "expected.json no tiene status PUBLISHED"
  fi
else
  ok "expected.json existe (o python3 no disponible)"
fi

echo ""
echo "Tests: $PASS pasaron, $FAIL fallaron"
if [[ $FAIL -eq 0 ]]; then
  echo "OK Tests pasaron"
  exit 0
else
  echo "FAIL Tests fallaron"
  exit 1
fi
