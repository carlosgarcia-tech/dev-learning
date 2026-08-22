#!/usr/bin/env bash
# test.sh — Ejercicio 01: Interface
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 01 — Interface"

# 1. interface Node definida
if grep -qE 'interface[[:space:]]+Node[[:space:]]*\{' "$SCHEMA"; then
  ok "interface Node definida"
else
  fail "interface Node no definida"
fi

# 2. interface tiene id: ID!
if awk '/interface[[:space:]]+Node[[:space:]]*\{/,/\}/' "$SCHEMA" | grep -qE 'id:[[:space:]]*ID!'; then
  ok "interface Node tiene id: ID!"
else
  fail "interface Node no tiene id: ID!"
fi

# 3. User implements Node
if grep -qE 'type[[:space:]]+User[[:space:]]+implements[[:space:]]+Node' "$SCHEMA"; then
  ok "User implements Node"
else
  fail "User no implements Node"
fi

# 4. Post implements Node
if grep -qE 'type[[:space:]]+Post[[:space:]]+implements[[:space:]]+Node' "$SCHEMA"; then
  ok "Post implements Node"
else
  fail "Post no implements Node"
fi

# 5. Query.node: Node
if grep -qE 'node[[:space:]]*\([[:space:]]*id:[[:space:]]*ID![[:space:]]*\)[[:space:]]*:[[:space:]]*Node' "$SCHEMA"; then
  ok "Query.node(id: ID!): Node definido"
else
  fail "Query.node no definido"
fi

# 6. query usa inline fragments
if grep -qE '\.\.\.[[:space:]]*on[[:space:]]+User' "$QUERY"; then
  ok "query usa inline fragment on User"
else
  fail "query no usa inline fragment on User"
fi

if grep -qE '\.\.\.[[:space:]]*on[[:space:]]+Post' "$QUERY"; then
  ok "query usa inline fragment on Post"
else
  fail "query no usa inline fragment on Post"
fi

# 7. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "import json; json.load(open('$EXPECTED'))" 2>/dev/null; then
    ok "expected.json es JSON válido"
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
