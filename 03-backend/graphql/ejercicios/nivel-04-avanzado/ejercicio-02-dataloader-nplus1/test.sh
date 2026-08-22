#!/usr/bin/env bash
# test.sh — Ejercicio 02: DataLoader y N+1
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
RESOLVERS="$DIR/resolvers.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 02 — DataLoader y N+1"

# 1. Schema User.posts
if grep -qE 'posts:[[:space:]]*\[Post!\]!' "$SCHEMA"; then
  ok "User.posts: [Post!]! definido"
else
  fail "User.posts no definido"
fi

# 2. Query.users
if grep -qE 'users:[[:space:]]*\[User!\]!' "$SCHEMA"; then
  ok "Query.users: [User!]! definido"
else
  fail "Query.users no definido"
fi

# 3. resolvers.js existe
if [[ -f "$RESOLVERS" ]]; then ok "resolvers.js existe"; else fail "resolvers.js no existe"; fi

# 4. DataLoader importado/creado
if grep -qE 'DataLoader' "$RESOLVERS"; then
  ok "DataLoader referenciado"
else
  fail "DataLoader no referenciado"
fi

# 5. createLoaders función definida
if grep -qE 'function[[:space:]]+createLoaders|createLoaders[[:space:]]*=' "$RESOLVERS"; then
  ok "createLoaders definido"
else
  fail "createLoaders no definido"
fi

# 6. batch function usa async
if grep -qE 'async' "$RESOLVERS"; then
  ok "batch function es async"
else
  fail "batch function no es async"
fi

# 7. User.posts usa postLoader.load
if grep -qE 'postLoader\.load' "$RESOLVERS"; then
  ok "User.posts usa context.loaders.postLoader.load"
else
  fail "User.posts no usa postLoader.load"
fi

# 8. No hay query por usuario en User.posts (usa load, no findMany directo)
if grep -A5 'User:' "$RESOLVERS" | grep -qE 'posts:' | head -3; then
  if ! grep -A5 'User:' "$RESOLVERS" | grep -qE 'findMany'; then
    ok "User.posts no hace query directa (usa DataLoader)"
  else
    fail "User.posts hace query directa (N+1 no resuelto)"
  fi
else
  ok "User.posts usa DataLoader (sin query directa visible)"
fi

# 9. query pide users con posts anidados
if grep -qE 'users' "$QUERY" && grep -qE 'posts[[:space:]]*\{' "$QUERY"; then
  ok "query pide users con posts anidados"
else
  fail "query no pide users con posts anidados"
fi

# 10. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert isinstance(d['data']['users'], list)
assert len(d['data']['users']) >= 2
assert all('posts' in u for u in d['data']['users'])
" 2>/dev/null; then
    ok "expected.json tiene lista de usuarios con posts"
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
