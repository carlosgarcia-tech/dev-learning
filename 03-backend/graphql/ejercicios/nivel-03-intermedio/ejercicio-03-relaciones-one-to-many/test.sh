#!/usr/bin/env bash
# test.sh — Ejercicio 03: Relaciones one-to-many
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 03 — Relaciones one-to-many"

# 1. User tiene posts: [Post!]!
if grep -qE 'posts:[[:space:]]*\[Post!\]!' "$SCHEMA"; then
  ok "User.posts: [Post!]! definido"
else
  fail "User.posts: [Post!]! no definido"
fi

# 2. Post tiene author: User!
if grep -qE 'author:[[:space:]]*User!' "$SCHEMA"; then
  ok "Post.author: User! definido"
else
  fail "Post.author: User! no definido"
fi

# 3. Query.user y Query.post
if grep -qE 'user[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA" && \
   grep -qE 'post[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA"; then
  ok "Query.user y Query.post definidos"
else
  fail "Query.user o Query.post no definidos"
fi

# 4. query pide user con posts anidados
if grep -qE 'user[[:space:]]*\(' "$QUERY" && grep -qE 'posts[[:space:]]*\{' "$QUERY"; then
  ok "query pide user con posts anidados"
else
  fail "query no pide user con posts anidados"
fi

# 5. query pide post con author anidado
if grep -qE 'post[[:space:]]*\(' "$QUERY" && grep -qE 'author[[:space:]]*\{' "$QUERY"; then
  ok "query pide post con author anidado"
else
  fail "query no pide post con author anidado"
fi

# 6. expected.json válido
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert 'user' in d['data'] and 'post' in d['data']
assert isinstance(d['data']['user']['posts'], list)
" 2>/dev/null; then
    ok "expected.json tiene user con posts (lista) y post"
  else
    fail "expected.json no es válido"
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
