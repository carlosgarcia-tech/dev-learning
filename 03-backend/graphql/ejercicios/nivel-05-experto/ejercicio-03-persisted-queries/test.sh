#!/usr/bin/env bash
# test.sh — Ejercicio 03: Persisted queries
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
CLIENT="$DIR/client.js"
SERVER="$DIR/server.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 03 — Persisted queries"

# 1. schema Query.posts
if grep -qE 'posts:[[:space:]]*\[Post!\]!' "$SCHEMA"; then
  ok "Query.posts: [Post!]! definido"
else
  fail "Query.posts no definido"
fi

# 2. client.js existe
if [[ -f "$CLIENT" ]]; then ok "client.js existe"; else fail "client.js no existe"; fi

# 3. client usa createPersistedQueryLink
if grep -qE 'createPersistedQueryLink' "$CLIENT"; then
  ok "client usa createPersistedQueryLink"
else
  fail "client no usa createPersistedQueryLink"
fi

# 4. client configura useGETForHashedQueries
if grep -qE 'useGETForHashedQueries' "$CLIENT"; then
  ok "client configura useGETForHashedQueries"
else
  fail "client no configura useGETForHashedQueries"
fi

# 5. client usa from con persistedLink y httpLink
if grep -qE 'from\(' "$CLIENT" && grep -qE 'persistedLink' "$CLIENT" && grep -qE 'httpLink' "$CLIENT"; then
  ok "client combina persistedLink y httpLink con from()"
else
  fail "client no combina persistedLink y httpLink"
fi

# 6. server.js existe
if [[ -f "$SERVER" ]]; then ok "server.js existe"; else fail "server.js no existe"; fi

# 7. server usa ApolloServer
if grep -qE 'ApolloServer' "$SERVER"; then
  ok "server usa ApolloServer"
else
  fail "server no usa ApolloServer"
fi

# 8. server configura plugins (cache control)
if grep -qE 'plugins' "$SERVER"; then
  ok "server configura plugins"
else
  fail "server no configura plugins"
fi

# 9. query tiene operation name
if grep -qE 'query[[:space:]]+GetPosts' "$QUERY"; then
  ok "query tiene operation name GetPosts"
else
  fail "query no tiene operation name"
fi

# 10. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert isinstance(d['data']['posts'], list)
" 2>/dev/null; then
    ok "expected.json tiene posts como lista"
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
