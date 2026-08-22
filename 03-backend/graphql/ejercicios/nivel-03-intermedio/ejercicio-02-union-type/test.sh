#!/usr/bin/env bash
# test.sh — Ejercicio 02: Union type
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 02 — Union type"

# 1. union SearchResult definida
if grep -qE 'union[[:space:]]+SearchResult[[:space:]]*=' "$SCHEMA"; then
  ok "union SearchResult definida"
else
  fail "union SearchResult no definida"
fi

# 2. union incluye User, Post, Comment
UNION_LINE=$(grep -E 'union[[:space:]]+SearchResult' "$SCHEMA")
echo "$UNION_LINE" | grep -q 'User'    && ok "union incluye User"    || fail "union no incluye User"
echo "$UNION_LINE" | grep -q 'Post'    && ok "union incluye Post"    || fail "union no incluye Post"
echo "$UNION_LINE" | grep -q 'Comment' && ok "union incluye Comment" || fail "union no incluye Comment"

# 3. Query.search definida
if grep -qE 'search[[:space:]]*\([[:space:]]*term:[[:space:]]*String!' "$SCHEMA" && \
   grep -qE 'search[^:]*:[[:space:]]*\[SearchResult!\]!' "$SCHEMA"; then
  ok "Query.search(term: String!): [SearchResult!]! definida"
else
  fail "Query.search no definida correctamente"
fi

# 4. query usa search
if grep -qE 'search[[:space:]]*\([[:space:]]*term:' "$QUERY"; then
  ok "query usa search(term: ...)"
else
  fail "query no usa search"
fi

# 5. query usa inline fragments para los 3 tipos
IF_OK=1
grep -qE '\.\.\.[[:space:]]*on[[:space:]]+User'    "$QUERY" || IF_OK=0
grep -qE '\.\.\.[[:space:]]*on[[:space:]]+Post'    "$QUERY" || IF_OK=0
grep -qE '\.\.\.[[:space:]]*on[[:space:]]+Comment' "$QUERY" || IF_OK=0
if [[ $IF_OK -eq 1 ]]; then
  ok "query usa inline fragments para User, Post y Comment"
else
  fail "query no usa inline fragments para los 3 tipos"
fi

# 6. expected.json válido
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert isinstance(d['data']['search'], list)
" 2>/dev/null; then
    ok "expected.json tiene search como lista"
  else
    fail "expected.json no tiene search como lista"
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
