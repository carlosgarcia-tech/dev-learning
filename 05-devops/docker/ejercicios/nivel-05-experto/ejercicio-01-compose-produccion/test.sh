#!/usr/bin/env bash
# test.sh — valida el ejercicio 01 nivel-05: Compose de producción
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"
[[ -f .env ]] && ok "existe .env" || fail "falta .env"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "compose config válido"; else fail "compose config inválido"; fi
  fi
  # 4 servicios
  for svc in proxy app db cache; do
    grep -qiE "^[[:space:]]*${svc}:" "$CF" && ok "servicio '${svc}'" || fail "falta servicio '${svc}'"
  done
  grep -qiE 'postgres:16-alpine' "$CF" && ok "db postgres:16-alpine" || fail "db debe usar postgres:16-alpine"
  grep -qiE 'redis:7-alpine' "$CF" && ok "cache redis:7-alpine" || fail "cache debe usar redis:7-alpine"
  grep -qiE 'nginx:1\.27-alpine' "$CF" && ok "proxy nginx:1.27-alpine" || fail "proxy debe usar nginx:1.27-alpine"
  grep -qiE 'pg_isready' "$CF" && ok "db healthcheck pg_isready" || fail "db debe tener healthcheck con pg_isready"
  grep -qiE 'service_healthy' "$CF" && ok "depends_on con service_healthy" || fail "falta depends_on con service_healthy"
  grep -qiE 'db_data:/var/lib/postgresql/data' "$CF" && ok "volumen db_data" || fail "db debe montar db_data"
  grep -qiE 'cache_data:/data' "$CF" && ok "volumen cache_data" || fail "cache debe montar cache_data"
  grep -qiE '8101:80' "$CF" && ok "proxy publica 8101:80" || fail "proxy debe publicar 8101:80"
  grep -qiE 'mem_limit:[[:space:]]*512m' "$CF" && ok "app mem_limit 512m" || fail "app debe tener mem_limit: 512m"
  # restart: always en todos
  N_RESTART=$(grep -ciE 'restart:[[:space:]]*always' "$CF")
  [[ "$N_RESTART" -ge 4 ]] && ok "restart: always en los servicios ($N_RESTART)" || fail "faltan restart: always (encontrados $N_RESTART, esperados >=4)"
  # Redes aisladas
  grep -qiE '^networks:' "$CF" && grep -qiE 'appnet' "$CF" && grep -qiE 'cachenet' "$CF" && ok "redes appnet y cachenet" || fail "define redes appnet y cachenet"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 8
    if curl -sf http://localhost:8101/health 2>/dev/null | grep -qi '"ok":true'; then
      ok "stack de producción healthy (app→db+cache)"
    else
      fail "stack no está healthy"
    fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
