#!/usr/bin/env bash
# test.sh — Ejercicio 03: Query con argumentos y listas
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 03 — Query con argumentos y listas"

# 1. Query.users con limit y offset
if grep -qE 'users[[:space:]]*\([[:space:]]*limit:[[:space:]]*Int' "$SCHEMA" && \
   grep -qE 'users[[:space:]]*\([^)]*offset:[[:space:]]*Int' "$SCHEMA"; then
  ok "Query.users(limit: Int, offset: Int) definido"
else
  fail "Query.users(limit, offset) no definido"
fi

# 2. Query.posts con limit
if grep -qE 'posts[[:space:]]*\([[:space:]]*limit:[[:space:]]*Int' "$SCHEMA"; then
  ok "Query.posts(limit: Int) definido"
else
  fail "Query.posts(limit: Int) no definido"
fi

# 3. Tipo de retorno [User!]!
if grep -qE 'users[^:]*:[[:space:]]*\[User!\]!' "$SCHEMA"; then
  ok "users devuelve [User!]!"
else
  fail "users no devuelve [User!]!"
fi

# 4. Tipo de retorno [Post!]!
if grep -qE 'posts[^:]*:[[:space:]]*\[Post!\]!' "$SCHEMA"; then
  ok "posts devuelve [Post!]!"
else
  fail "posts no devuelve [Post!]!"
fi

# 5. Query pide users(limit: 5)
if grep -qE 'users[[:space:]]*\([[:space:]]*limit:[[:space:]]*5' "$QUERY"; then
  ok "query pide users(limit: 5)"
else
  fail "query no pide users(limit: 5)"
fi

# 6. Query pide posts(limit: 3)
if grep -qE 'posts[[:space:]]*\([[:space:]]*limit:[[:space:]]*3' "$QUERY"; then
  ok "query pide posts(limit: 3)"
else
  fail "query no pide posts(limit: 3)"
fi

# 7. Selecciona id y name en users
if grep -qE 'users[[:space:]]*\([^)]*\)[[:space:]]*\{[^}]*\bid\b[^}]*\bname\b' "$QUERY"; then
  ok "query selecciona id y name en users"
else
  fail "query no selecciona id y name en users"
fi

# 8. expected.json válido con arrays
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "import json; json.load(open('$EXPECTED'))" 2>/dev/null; then
    ok "expected.json es JSON válido"
    if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert isinstance(d['data']['users'], list)
assert isinstance(d['data']['posts'], list)
" 2>/dev/null; then
      ok "expected.json tiene listas en users y posts"
    else
      fail "expected.json no tiene listas en users y posts"
    fi
  else
    fail "expected.json no es JSON válido"
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
