#!/usr/bin/env bash
# test.sh — valida el ejercicio 01 nivel-03: Compose con 2 servicios (app + db)
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "docker compose config válido"; else fail "docker compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*app:' "$CF" && ok "servicio 'app'" || fail "falta servicio 'app'"
  grep -qiE '^[[:space:]]*db:' "$CF" && ok "servicio 'db'" || fail "falta servicio 'db'"
  grep -qiE 'postgres:16-alpine' "$CF" && ok "db usa postgres:16-alpine" || fail "db debe usar postgres:16-alpine"
  grep -qiE 'pg_isready' "$CF" && ok "healthcheck con pg_isready" || fail "db debe tener healthcheck con pg_isready"
  grep -qiE 'service_healthy' "$CF" && ok "depends_on con service_healthy" || fail "app debe usar depends_on con condition: service_healthy"
  grep -qiE 'db_data:/var/lib/postgresql/data' "$CF" && ok "db monta db_data" || fail "db debe montar db_data en /var/lib/postgresql/data"
  grep -qiE '^volumes:' "$CF" && grep -qiE '^[[:space:]]*db_data:' "$CF" && ok "volumen db_data top-level" || fail "define volumen db_data en top-level"
  grep -qiE '^networks:' "$CF" && grep -qiE 'appnet' "$CF" && ok "red appnet top-level" || fail "define red appnet"
  grep -qiE '8091:3000' "$CF" && ok "app publica 8091:3000" || fail "app debe publicar 8091:3000"
  grep -qiE 'POSTGRES_USER' "$CF" && grep -qiE 'POSTGRES_PASSWORD' "$CF" && grep -qiE 'POSTGRES_DB' "$CF" && ok "db tiene env de Postgres" || fail "db necesita POSTGRES_USER/PASSWORD/DB"
fi

[[ -f .env ]] && ok "existe .env" || fail "falta .env"

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 6
    if curl -sf http://localhost:8091/ 2>/dev/null | grep -qi '"reachable":true'; then
      ok "app alcanza a la BBDD"
    else
      fail "app no alcanza a la BBDD"
    fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
