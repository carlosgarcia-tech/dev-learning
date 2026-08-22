#!/usr/bin/env bash
# test.sh — Ejercicio 04: Paginación (Relay)
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 04 — Paginación (Relay)"

# 1. PostConnection definido
if grep -qE 'type[[:space:]]+PostConnection[[:space:]]*\{' "$SCHEMA"; then
  ok "type PostConnection definido"
else
  fail "type PostConnection no definido"
fi

# 2. PostEdge definido
if grep -qE 'type[[:space:]]+PostEdge[[:space:]]*\{' "$SCHEMA"; then
  ok "type PostEdge definido"
else
  fail "type PostEdge no definido"
fi

# 3. PageInfo definido
if grep -qE 'type[[:space:]]+PageInfo[[:space:]]*\{' "$SCHEMA"; then
  ok "type PageInfo definido"
else
  fail "type PageInfo no definido"
fi

# 4. PostConnection tiene edges y pageInfo
if grep -qE 'edges:[[:space:]]*\[PostEdge!\]!' "$SCHEMA" && grep -qE 'pageInfo:[[:space:]]*PageInfo!' "$SCHEMA"; then
  ok "PostConnection tiene edges y pageInfo"
else
  fail "PostConnection no tiene edges y pageInfo"
fi

# 5. PostEdge tiene cursor y node
if grep -qE 'cursor:[[:space:]]*String!' "$SCHEMA" && grep -qE 'node:[[:space:]]*Post!' "$SCHEMA"; then
  ok "PostEdge tiene cursor y node"
else
  fail "PostEdge no tiene cursor y node"
fi

# 6. PageInfo tiene hasNextPage
if grep -qE 'hasNextPage:[[:space:]]*Boolean!' "$SCHEMA"; then
  ok "PageInfo tiene hasNextPage: Boolean!"
else
  fail "PageInfo no tiene hasNextPage"
fi

# 7. Query.posts(first, after): PostConnection!
if grep -qE 'posts[[:space:]]*\([[:space:]]*first:[[:space:]]*Int' "$SCHEMA" && \
   grep -qE 'posts[^:]*:[[:space:]]*PostConnection!' "$SCHEMA"; then
  ok "Query.posts(first, after): PostConnection! definido"
else
  fail "Query.posts no definido correctamente"
fi

# 8. query pide first
if grep -qE 'posts[[:space:]]*\([[:space:]]*first:' "$QUERY"; then
  ok "query pide posts(first: ...)"
else
  fail "query no pide posts(first: ...)"
fi

# 9. query pide edges con cursor y node
if grep -qE 'edges[[:space:]]*\{' "$QUERY" && grep -qi 'cursor' "$QUERY" && grep -qi 'node' "$QUERY"; then
  ok "query pide edges con cursor y node"
else
  fail "query no pide edges con cursor y node"
fi

# 10. query pide pageInfo
if grep -qE 'pageInfo[[:space:]]*\{' "$QUERY"; then
  ok "query pide pageInfo"
else
  fail "query no pide pageInfo"
fi

# 11. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
p = d['data']['posts']
assert 'edges' in p and 'pageInfo' in p
assert isinstance(p['edges'], list)
" 2>/dev/null; then
    ok "expected.json tiene edges y pageInfo"
  else
    fail "expected.json no tiene edges y pageInfo"
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
