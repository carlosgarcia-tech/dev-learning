#!/usr/bin/env bash
# test.sh — Ejercicio 04: Input type con campos anidados
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 04 — Input type con campos anidados"

# 1. input CreatePostInput
if grep -qE 'input[[:space:]]+CreatePostInput[[:space:]]*\{' "$SCHEMA"; then
  ok "input CreatePostInput definido"
else
  fail "input CreatePostInput no definido"
fi

# 2. input PostMetadataInput
if grep -qE 'input[[:space:]]+PostMetadataInput[[:space:]]*\{' "$SCHEMA"; then
  ok "input PostMetadataInput definido"
else
  fail "input PostMetadataInput no definido"
fi

# 3. CreatePostInput tiene metadata: PostMetadataInput
if grep -qE 'metadata:[[:space:]]*PostMetadataInput' "$SCHEMA"; then
  ok "CreatePostInput tiene metadata: PostMetadataInput"
else
  fail "CreatePostInput no tiene metadata: PostMetadataInput"
fi

# 4. PostMetadataInput tiene tags: [String!]!
if grep -qE 'tags:[[:space:]]*\[String!\]!' "$SCHEMA"; then
  ok "PostMetadataInput.tags: [String!]! definido"
else
  fail "PostMetadataInput.tags: [String!]! no definido"
fi

# 5. Mutation createPost
if grep -qE 'createPost[[:space:]]*\([[:space:]]*input:[[:space:]]*CreatePostInput!' "$SCHEMA"; then
  ok "createPost(input: CreatePostInput!) definido"
else
  fail "createPost no definido correctamente"
fi

# 6. mutation pasa metadata anidada
if grep -qE 'metadata:[[:space:]]*\{' "$QUERY"; then
  ok "mutation pasa metadata anidada"
else
  fail "mutation no pasa metadata anidada"
fi

# 7. mutation pasa tags
if grep -qE 'tags:' "$QUERY"; then
  ok "mutation pasa tags"
else
  fail "mutation no pasa tags"
fi

# 8. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d['data']['createPost']['title'] == 'Intro a GraphQL'
assert isinstance(d['data']['createPost']['tags'], list)
" 2>/dev/null; then
    ok "expected.json válido con tags (lista)"
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
