#!/usr/bin/env bash
# test.sh — valida el ejercicio 05 nivel-03: multi-stage optimizado
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
    N_FROM=$(grep -ciE '^FROM' "$DF")
    if [[ "$N_FROM" -ge 3 ]]; then ok "3 stages ($N_FROM FROM)"; else fail "Se necesitan 3 FROM (deps, builder, runtime)"; fi
    grep -qiE 'AS[[:space:]]+deps' "$DF" && ok "stage 'deps'" || fail "Falta stage 'AS deps'"
    grep -qiE 'AS[[:space:]]+builder' "$DF" && ok "stage 'builder'" || fail "Falta stage 'AS builder'"
    grep -qiE '^COPY[[:space:]]+--from=deps' "$DF" && ok "COPY --from=deps" || fail "Falta 'COPY --from=deps'"
    grep -qiE '^COPY[[:space:]]+--from=builder' "$DF" && ok "COPY --from=builder" || fail "Falta 'COPY --from=builder'"
    grep -qiE '^RUN[[:space:]].*npm[[:space:]]+run[[:space:]]+build' "$DF" && ok "npm run build en builder" || fail "El builder debe ejecutar 'npm run build'"
    grep -qiE '^USER[[:space:]]+app' "$DF" && ok "USER app" || fail "Falta 'USER app' en runtime"
    grep -qiE '^HEALTHCHECK' "$DF" && ok "HEALTHCHECK presente" || fail "Falta HEALTHCHECK"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'node.*dist/server\.js' "$DF" && ok "CMD ejecuta dist/server.js" || fail "CMD debe ejecutar node dist/server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej03-05-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker run -d --rm --name "ej03-05-$$" -p 13020:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    if curl -sf http://localhost:13020/health >/dev/null 2>&1; then ok "app responde /health"; else fail "app no responde /health"; fi
    # Verificar usuario no root
    if docker exec "ej03-05-$$" id 2>/dev/null | grep -qi 'app'; then ok "contenedor corre como 'app'"; else fail "contenedor no corre como usuario 'app'"; fi
    docker stop "ej03-05-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
