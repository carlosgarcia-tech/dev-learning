#!/usr/bin/env bash
# test.sh — valida el ejercicio 02 nivel-04: usuario no root (hardening)
set -euo pipefail
cd "$(dirname "$0")"

DF="Dockerfile"
CF="docker-compose.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$DF" ]] && ok "existe Dockerfile" || fail "no existe Dockerfile"
[[ -f "$CF" ]] && ok "existe docker-compose.yml" || fail "no existe docker-compose.yml"

if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    grep -qiE '^FROM[[:space:]]+node:20-alpine' "$DF" && ok "FROM node:20-alpine" || fail "Falta FROM node:20-alpine"
    grep -qiE 'addgroup.*10001|adduser.*10001' "$DF" && ok "crea usuario UID 10001" || fail "Crea usuario con UID 10001"
    grep -qiE '^COPY[[:space:]].*--chown=app:app' "$DF" && ok "COPY --chown=app:app" || fail "Usa COPY --chown=app:app"
    grep -qiE '^USER[[:space:]]+app' "$DF" && ok "USER app" || fail "Falta 'USER app'"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
  fi
fi

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "compose config válido"; else fail "compose config inválido"; fi
  fi
  grep -qiE 'read_only:[[:space:]]*true' "$CF" && ok "read_only: true" || fail "falta 'read_only: true'"
  grep -qiE 'tmpfs' "$CF" && ok "tmpfs /tmp" || fail "falta 'tmpfs: [\"/tmp\"]'"
  grep -qiE 'cap_drop' "$CF" && grep -qiE 'ALL' "$CF" && ok "cap_drop: [ALL]" || fail "falta 'cap_drop: [ALL]'"
  grep -qiE 'no-new-privileges' "$CF" && ok "security_opt no-new-privileges" || fail "falta 'security_opt: [no-new-privileges:true]'"
  grep -qiE 'user:[[:space:]]*"10001:10001"|user:[[:space:]]+10001:10001' "$CF" && ok "user 10001:10001" || fail "falta 'user: \"10001:10001\"'"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 3
    if BODY="$(curl -sf http://localhost:8096/ 2>/dev/null || true)"; then
      echo "$BODY" | grep -qi '"uid":10001' && ok "corre como UID 10001" || fail "no corre como UID 10001 (body: $BODY)"
    else fail "app no responde"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
