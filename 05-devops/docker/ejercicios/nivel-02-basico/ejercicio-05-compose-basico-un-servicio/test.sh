#!/usr/bin/env bash
# test.sh — valida el ejercicio 05 nivel-02: Compose básico de 1 servicio
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
DF="Dockerfile"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"
[[ -f "$DF" ]] && ok "existe $DF" || fail "no existe $DF"
[[ -f .env ]] && ok "existe .env" || fail "falta .env"

if [[ -f .env ]] && grep -qiE '^WEB_PORT=' .env; then ok ".env define WEB_PORT"; else fail ".env debe definir WEB_PORT"; fi

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "docker compose config válido"; else fail "docker compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*web:' "$CF" && ok "servicio 'web' definido" || fail "falta servicio 'web'"
  grep -qiE 'build:[[:space:]]*\.' "$CF" && ok "web usa build: ." || fail "web debe usar 'build: .'"
  grep -qiE '\$\{WEB_PORT' "$CF" && ok "puerto usa \${WEB_PORT}" || fail "el puerto debe usar \${WEB_PORT:-8080}:3000"
  grep -qiE '3000' "$CF" && ok "puerto del contenedor 3000" || fail "el puerto del contenedor debe ser 3000"
  grep -qiE 'NODE_ENV' "$CF" && ok "define NODE_ENV" || fail "falta variable NODE_ENV"
  grep -qiE 'unless-stopped' "$CF" && ok "restart unless-stopped" || fail "falta 'restart: unless-stopped'"
fi

if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    grep -qiE '^FROM[[:space:]]+node:20-alpine' "$DF" && ok "FROM node:20-alpine" || fail "Falta FROM node:20-alpine"
    grep -qiE '^WORKDIR[[:space:]]+/app' "$DF" && ok "WORKDIR /app" || fail "Falta WORKDIR /app"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
  fi
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 3
    if curl -sf http://localhost:8080/ >/dev/null 2>&1; then ok "web responde en 8080"; else fail "web no responde en 8080"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
