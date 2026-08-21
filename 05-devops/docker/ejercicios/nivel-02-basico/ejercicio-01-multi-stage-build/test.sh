#!/usr/bin/env bash
# test.sh — valida el ejercicio 01 nivel-02: multi-stage build
set -euo pipefail
cd "$(dirname "$0")"

DF="Dockerfile"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$DF" ]] && ok "existe $DF" || fail "no existe $DF"

if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    # Múltiples FROM (multi-stage)
    N_FROM=$(grep -ciE '^FROM' "$DF")
    if [[ "$N_FROM" -ge 2 ]]; then ok "multi-stage ($N_FROM FROM)"; else fail "Se necesitan al menos 2 FROM (multi-stage)"; fi
    # Stage builder nombrado
    if grep -qiE '^FROM[[:space:]].*AS[[:space:]]+builder' "$DF"; then ok "stage 'builder' nombrado"; else fail "Falta 'FROM ... AS builder'"; fi
    # COPY --from=builder
    if grep -qiE '^COPY[[:space:]]+--from=builder' "$DF"; then ok "COPY --from=builder presente"; else fail "Falta 'COPY --from=builder'"; fi
    # Runtime usa --omit=dev
    grep -qiE 'omit=dev|--omit=dev|--production' "$DF" && ok "runtime omite dev deps" || fail "El runtime debe usar --omit=dev"
    # Builder usa npm ci completo (sin omit)
    if awk '/AS builder/{f=1} f&&/^FROM/{if(NR>1)exit} f&&/npm ci/{print}' "$DF" | grep -qiE 'npm[[:space:]]+ci' && ! awk '/AS builder/{f=1} f&&/^FROM/{if(NR>1)exit} f&&/npm ci/{print}' "$DF" | grep -qiE 'omit=dev'; then
      ok "builder instala deps completas"
    else
      fail "El builder debe instalar deps completas (npm ci sin --omit=dev)"
    fi
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'node.*dist/server\.js' "$DF" && ok "CMD ejecuta dist/server.js" || fail "CMD debe ejecutar node dist/server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej02-01-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker run -d --rm --name "ej02-01-$$" -p 13005:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    if curl -sf http://localhost:13005/ >/dev/null 2>&1; then ok "app responde"; else fail "app no responde"; fi
    docker stop "ej02-01-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
