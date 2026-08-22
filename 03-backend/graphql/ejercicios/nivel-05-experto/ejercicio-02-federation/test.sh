#!/usr/bin/env bash
# test.sh — Ejercicio 02: Federation
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_SCHEMA="$DIR/users-service.graphql"
POSTS_SCHEMA="$DIR/posts-service.graphql"
GATEWAY="$DIR/gateway.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 02 — Federation"

# 1. users-service con @key
if grep -qE '@key[[:space:]]*\(' "$USERS_SCHEMA"; then
  ok "users-service usa @key"
else
  fail "users-service no usa @key"
fi

# 2. users-service define type User
if grep -qE 'type[[:space:]]+User' "$USERS_SCHEMA"; then
  ok "users-service define type User"
else
  fail "users-service no define type User"
fi

# 3. posts-service extiende User
if grep -qE 'type[[:space:]]+User' "$POSTS_SCHEMA"; then
  ok "posts-service define type User (extendido)"
else
  fail "posts-service no define type User"
fi

# 4. posts-service usa @external
if grep -qE '@external' "$POSTS_SCHEMA"; then
  ok "posts-service usa @external"
else
  fail "posts-service no usa @external"
fi

# 5. posts-service usa @key en User
if grep -qE 'type[[:space:]]+User[^{]*@key' "$POSTS_SCHEMA" || grep -B2 'type User' "$POSTS_SCHEMA" | grep -q '@key'; then
  ok "posts-service User tiene @key"
else
  fail "posts-service User no tiene @key"
fi

# 6. posts-service User tiene posts
if grep -qE 'posts:[[:space:]]*\[Post!\]!' "$POSTS_SCHEMA"; then
  ok "posts-service User tiene posts: [Post!]!"
else
  fail "posts-service User no tiene posts"
fi

# 7. gateway.js existe y usa ApolloGateway
if [[ -f "$GATEWAY" ]] && grep -qE 'ApolloGateway' "$GATEWAY"; then
  ok "gateway.js usa ApolloGateway"
else
  fail "gateway.js no usa ApolloGateway"
fi

# 8. gateway tiene serviceList con users y posts
if grep -qE 'users' "$GATEWAY" && grep -qE 'posts' "$GATEWAY"; then
  ok "gateway tiene serviceList con users y posts"
else
  fail "gateway no tiene serviceList con users y posts"
fi

# 9. query pide user con posts (cross-service)
if grep -qE 'user' "$QUERY" && grep -qE 'posts[[:space:]]*\{' "$QUERY"; then
  ok "query pide user con posts (cross-service)"
else
  fail "query no pide user con posts"
fi

# 10. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
u = d['data']['user']
assert 'name' in u and 'posts' in u
" 2>/dev/null; then
    ok "expected.json tiene user con name y posts"
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
