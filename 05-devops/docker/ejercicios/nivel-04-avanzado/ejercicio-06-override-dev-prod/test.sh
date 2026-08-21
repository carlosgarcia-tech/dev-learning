#!/usr/bin/env bash
# test.sh — valida el ejercicio 06 nivel-04: override de Compose dev/prod
set -euo pipefail
cd "$(dirname "$0")"

BASE="docker-compose.yml"
DEV="docker-compose.dev.yml"
PROD="docker-compose.prod.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

for f in "$BASE" "$DEV" "$PROD"; do
  [[ -f "$f" ]] && ok "existe $f" || fail "no existe $f"
done

# Base
if [[ -f "$BASE" ]]; then
  grep -qiE '^[[:space:]]*app:' "$BASE" && ok "base: servicio app" || fail "base: falta servicio app"
  grep -qiE 'NODE_ENV:[[:space:]]*production' "$BASE" && ok "base: NODE_ENV=production" || fail "base: NODE_ENV debe ser production"
  grep -qiE '8100:3000' "$BASE" && ok "base: puerto 8100:3000" || fail "base: debe publicar 8100:3000"
fi

# Dev override
if [[ -f "$DEV" ]]; then
  grep -qiE 'NODE_ENV:[[:space:]]*development' "$DEV" && ok "dev: NODE_ENV=development" || fail "dev: NODE_ENV debe ser development"
  grep -qiE '\./app/src:/app/src' "$DEV" && ok "dev: bind mount ./app/src" || fail "dev: falta bind mount ./app/src:/app/src"
  grep -qiE 'command' "$DEV" && grep -qiE '\-\-watch' "$DEV" && ok "dev: command node --watch" || fail "dev: falta command con --watch"
fi

# Prod override
if [[ -f "$PROD" ]]; then
  grep -qiE 'mem_limit:[[:space:]]*256m' "$PROD" && ok "prod: mem_limit 256m" || fail "prod: falta mem_limit 256m"
  grep -qiE 'cpus:[[:space:]]*"0\.5"|cpus:[[:space:]]+0\.5' "$PROD" && ok "prod: cpus 0.5" || fail "prod: falta cpus \"0.5\""
  grep -qiE 'read_only:[[:space:]]*true' "$PROD" && ok "prod: read_only true" || fail "prod: falta read_only: true"
  grep -qiE 'tmpfs' "$PROD" && ok "prod: tmpfs /tmp" || fail "prod: falta tmpfs"
  grep -qiE 'restart:[[:space:]]*always' "$PROD" && ok "prod: restart always" || fail "prod: falta restart: always"
fi

# Validación de fusión con docker compose config
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  if docker compose -f "$BASE" -f "$DEV" config >/dev/null 2>&1; then ok "compose config (base+dev) válido"; else fail "compose config (base+dev) inválido"; fi
  if docker compose -f "$BASE" -f "$PROD" config >/dev/null 2>&1; then ok "compose config (base+prod) válido"; else fail "compose config (base+prod) inválido"; fi
  # Verificar que dev sobrescribe NODE_ENV
  MERGED=$(docker compose -f "$BASE" -f "$DEV" config 2>/dev/null || true)
  if echo "$MERGED" | grep -qiE 'NODE_ENV:[[:space:]]*development'; then ok "fusión dev: NODE_ENV=development"; else fail "fusión dev: NODE_ENV no se sobrescribe"; fi
  # Verificar que prod añade read_only
  MERGED_PROD=$(docker compose -f "$BASE" -f "$PROD" config 2>/dev/null || true)
  if echo "$MERGED_PROD" | grep -qiE 'read_only:[[:space:]]*true'; then ok "fusión prod: read_only aplicado"; else fail "fusión prod: read_only no se aplica"; fi
fi

if [[ -f "$BASE" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$BASE" -f "$DEV" up -d --build >/dev/null 2>&1; then
    ok "docker compose up (base+dev) OK"
    sleep 3
    if BODY="$(curl -sf http://localhost:8100/ 2>/dev/null || true)"; then
      echo "$BODY" | grep -qi '"env":"development"' && ok "dev: app corre en development" || fail "dev: app no está en development (body: $BODY)"
    else fail "dev: app no responde"; fi
    docker compose -f "$BASE" -f "$DEV" down -v >/dev/null 2>&1 || true
  else fail "docker compose up (base+dev) falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
