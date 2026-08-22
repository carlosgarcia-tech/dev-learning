#!/usr/bin/env bash
# test.sh — Ejercicio 04: Subscription con WebSocket
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

echo "Ejercicio 04 — Subscription con WebSocket"

# 1. type Subscription en schema
if grep -qE 'type[[:space:]]+Subscription[[:space:]]*\{' "$SCHEMA"; then
  ok "type Subscription definido"
else
  fail "type Subscription no definido"
fi

# 2. postAdded: Post!
if grep -qE 'postAdded:[[:space:]]*Post!' "$SCHEMA"; then
  ok "postAdded: Post! definido"
else
  fail "postAdded: Post! no definido"
fi

# 3. Mutation createPost
if grep -qE 'createPost[[:space:]]*\(' "$SCHEMA"; then
  ok "Mutation.createPost definido"
else
  fail "Mutation.createPost no definido"
fi

# 4. resolvers.js existe
if [[ -f "$RESOLVERS" ]]; then ok "resolvers.js existe"; else fail "resolvers.js no existe"; fi

# 5. Subscription.postAdded.subscribe usa asyncIterator
if grep -qE 'subscribe' "$RESOLVERS" && grep -qE 'asyncIterator' "$RESOLVERS"; then
  ok "Subscription.postAdded.subscribe usa asyncIterator"
else
  fail "subscribe no usa asyncIterator"
fi

# 6. pubsub usado
if grep -qE 'PubSub' "$RESOLVERS"; then
  ok "PubSub referenciado"
else
  fail "PubSub no referenciado"
fi

# 7. Mutation.createPost publica en pubsub
if grep -qE 'pubsub\.publish' "$RESOLVERS"; then
  ok "createPost publica en pubsub"
else
  fail "createPost no publica en pubsub"
fi

# 8. query es subscription
if grep -qE '^[[:space:]]*subscription' "$QUERY"; then
  ok "query declarada como subscription"
else
  fail "query no es subscription"
fi

# 9. query pide postAdded
if grep -qi 'postAdded' "$QUERY"; then
  ok "query pide postAdded"
else
  fail "query no pide postAdded"
fi

# 10. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert 'postAdded' in d['data']
" 2>/dev/null; then
    ok "expected.json tiene postAdded"
  else
    fail "expected.json no tiene postAdded"
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
