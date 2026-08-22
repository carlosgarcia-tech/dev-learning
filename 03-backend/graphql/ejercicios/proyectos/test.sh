#!/usr/bin/env bash
# test.sh — Proyecto final: API GraphQL de red social
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER="$DIR/starter"
SCHEMA="$STARTER/schema.graphql"
SERVER="$STARTER/server.js"
RESOLVERS="$STARTER/resolvers.js"
CONTEXT="$STARTER/context.js"
README="$DIR/README.md"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Proyecto final — API GraphQL de red social"

# --- Archivos starter presentes ---
for f in schema.graphql server.js resolvers.js context.js; do
  if [[ -f "$STARTER/$f" ]]; then ok "starter/$f existe"; else fail "starter/$f no existe"; fi
done

# --- Tipos requeridos en el schema ---
for t in "type User" "type Post" "type Comment" "type Like" "type Follow" "type Notification" "type PageInfo" "type PostConnection"; do
  if grep -qE "$t" "$SCHEMA"; then ok "schema define $t"; else fail "schema no define $t"; fi
done

# --- Queries requeridas ---
for q in "me:" "user(" "posts(" "post(" "notifications:"; do
  if grep -qE "$q" "$SCHEMA"; then ok "Query $q definida"; else fail "Query $q no definida"; fi
done

# --- Mutations requeridas ---
for m in "register(" "login(" "createPost(" "createComment(" "toggleLike(" "follow(" "unfollow("; do
  if grep -qE "$m" "$SCHEMA"; then ok "Mutation $m definida"; else fail "Mutation $m no definida"; fi
done

# --- Subscriptions requeridas ---
for s in "postCreated" "commentAdded"; do
  if grep -qE "$s" "$SCHEMA"; then ok "Subscription $s definida"; else fail "Subscription $s no definida"; fi
done

# --- Directiva @auth ---
if grep -qE 'directive @auth' "$SCHEMA" && grep -qE '@auth' "$SCHEMA"; then
  ok "directiva @auth definida y usada"
else
  fail "directiva @auth no definida o no usada"
fi

# --- Paginación ---
if grep -qE 'PageInfo' "$SCHEMA" && grep -qE 'hasNextPage' "$SCHEMA"; then
  ok "paginación definida (PageInfo + hasNextPage)"
else
  fail "paginación no definida"
fi

# --- context.js: JWT y loaders ---
if grep -qE 'jwt' "$CONTEXT" && grep -qE 'authorization' "$CONTEXT"; then
  ok "context.js extrae usuario del header JWT"
else
  fail "context.js no extrae usuario JWT"
fi

if grep -qE 'DataLoader' "$CONTEXT"; then
  ok "context.js inicializa DataLoader"
else
  fail "context.js no inicializa DataLoader"
fi

# --- resolvers.js: DataLoader, requireAuth, PubSub ---
if grep -qE 'DataLoader|loaders' "$RESOLVERS"; then
  ok "resolvers.js usa DataLoader en relaciones"
else
  fail "resolvers.js no usa DataLoader"
fi

if grep -qE 'requireAuth|UNAUTHENTICATED' "$RESOLVERS"; then
  ok "resolvers.js protege mutations (UNAUTHENTICATED)"
else
  fail "resolvers.js no protege mutations"
fi

if grep -qE 'pubsub|PubSub|asyncIterator' "$RESOLVERS"; then
  ok "resolvers.js usa PubSub para subscriptions"
else
  fail "resolvers.js no usa PubSub"
fi

# --- server.js: Apollo, Express, WebSocket ---
if grep -qE 'ApolloServer' "$SERVER"; then
  ok "server.js configura ApolloServer"
else
  fail "server.js no configura ApolloServer"
fi

if grep -qE 'WebSocketServer|graphql-ws|ws' "$SERVER"; then
  ok "server.js configura WebSocket para subscriptions"
else
  fail "server.js no configura WebSocket"
fi

# --- README: fases y criterios ---
if grep -qiE 'fase' "$README" && grep -qiE 'criterios de aceptación' "$README"; then
  ok "README documenta fases y criterios"
else
  fail "README no documenta fases/criterios"
fi

# --- Sintaxis JS válida ---
if command -v node >/dev/null 2>&1; then
  ALL_OK=1
  for js in server.js resolvers.js context.js; do
    if ! node --check "$STARTER/$js" 2>/dev/null; then
      ALL_OK=0
    fi
  done
  if [[ $ALL_OK -eq 1 ]]; then
    ok "Sintaxis JS válida (node --check)"
  else
    fail "Sintaxis JS inválida en algún archivo starter"
  fi
else
  ok "node no disponible, sintaxis no verificada"
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
