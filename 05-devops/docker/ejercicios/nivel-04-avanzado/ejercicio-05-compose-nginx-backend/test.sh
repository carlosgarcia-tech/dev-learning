#!/usr/bin/env bash
# test.sh — valida el ejercicio 05 nivel-04: Compose con nginx y backend
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
NGINX_CONF="nginx/default.conf"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"
[[ -f "$NGINX_CONF" ]] && ok "existe nginx/default.conf" || fail "falta nginx/default.conf"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "compose config válido"; else fail "compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*proxy:' "$CF" && ok "servicio 'proxy'" || fail "falta servicio 'proxy'"
  grep -qiE '^[[:space:]]*backend:' "$CF" && ok "servicio 'backend'" || fail "falta servicio 'backend'"
  grep -qiE 'nginx:1\.27-alpine' "$CF" && ok "proxy usa nginx:1.27-alpine" || fail "proxy debe usar nginx:1.27-alpine"
  grep -qiE '8099:80' "$CF" && ok "proxy publica 8099:80" || fail "proxy debe publicar 8099:80"
  grep -qiE 'default\.conf' "$CF" && ok "monta default.conf" || fail "proxy debe montar ./nginx/default.conf"
  grep -qiE 'build:[[:space:]]+\./app' "$CF" && ok "backend usa build ./app" || fail "backend debe usar 'build: ./app'"
  grep -qiE 'proxynet' "$CF" && ok "red proxynet" || fail "falta red proxynet"
  # backend NO debe tener ports
  if awk '/^[[:space:]]*backend:/{f=1} f&&/^[[:space:]]+[a-z]/&&!/backend:/{if($1=="ports:")exit 1} /^networks:/{exit}' "$CF"; then
    ok "backend sin puertos publicados"
  else
    fail "backend no debe tener 'ports:' (solo accesible por nginx dentro de la red)"
  fi
fi

if [[ -f "$NGINX_CONF" ]]; then
  grep -qiE 'proxy_pass[[:space:]]+http://backend:3000' "$NGINX_CONF" && ok "proxy_pass http://backend:3000" || fail "nginx debe hacer proxy_pass http://backend:3000"
  grep -qiE 'listen[[:space:]]+80' "$NGINX_CONF" && ok "nginx escucha 80" || fail "nginx debe escuchar en 80"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 4
    if BODY="$(curl -sf http://localhost:8099/ 2>/dev/null || true)"; then
      echo "$BODY" | grep -qi '"from":"backend"' && ok "nginx proxya al backend" || fail "nginx no proxya al backend (body: $BODY)"
    else fail "proxy no responde en 8099"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
