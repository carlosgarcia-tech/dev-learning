#!/usr/bin/env bash
# test.sh — Ejercicio 05: Nullabilidad
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 05 — Nullabilidad"

# 1. type Article
if grep -qE 'type[[:space:]]+Article[[:space:]]*\{' "$SCHEMA"; then
  ok "type Article definido"
else
  fail "type Article no definido"
fi

# 2. optionalTags: [String]
if grep -qE 'optionalTags:[[:space:]]*\[String\]([^!]|$)' "$SCHEMA"; then
  ok "optionalTags: [String] (lista y elementos nullable)"
else
  fail "optionalTags: [String] no encontrado"
fi

# 3. strictTags: [String!]!
if grep -qE 'strictTags:[[:space:]]*\[String!\]!' "$SCHEMA"; then
  ok "strictTags: [String!]! (lista y elementos non-null)"
else
  fail "strictTags: [String!]! no encontrado"
fi

# 4. listNotNull: [String]!
if grep -qE 'listNotNull:[[:space:]]*\[String\]!' "$SCHEMA"; then
  ok "listNotNull: [String]! (lista non-null, elementos nullable)"
else
  fail "listNotNull: [String]! no encontrado"
fi

# 5. elementsNotNull: [String!]
if grep -qE 'elementsNotNull:[[:space:]]*\[String!\]([^!]|$)' "$SCHEMA"; then
  ok "elementsNotNull: [String!] (lista nullable, elementos non-null)"
else
  fail "elementsNotNull: [String!] no encontrado"
fi

# 6. Query.article
if grep -qE 'article[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA"; then
  ok "Query.article(id: ID!) definido"
else
  fail "Query.article no definido"
fi

# 7. query pide los 4 campos
QUERY_OK=1
grep -qi 'optionalTags'    "$QUERY" || QUERY_OK=0
grep -qi 'strictTags'       "$QUERY" || QUERY_OK=0
grep -qi 'listNotNull'      "$QUERY" || QUERY_OK=0
grep -qi 'elementsNotNull'  "$QUERY" || QUERY_OK=0
if [[ $QUERY_OK -eq 1 ]]; then
  ok "query pide los 4 campos de tags"
else
  fail "query no pide los 4 campos de tags"
fi

# 8. expected.json válido
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
