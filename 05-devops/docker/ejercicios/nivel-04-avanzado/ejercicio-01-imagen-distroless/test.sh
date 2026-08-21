#!/usr/bin/env bash
# test.sh — valida el ejercicio 01 nivel-04: imagen distroless
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
    [[ "$N_FROM" -ge 2 ]] && ok "multi-stage ($N_FROM FROM)" || fail "Se necesitan 2 FROM (builder + distroless)"
    grep -qiE 'AS[[:space:]]+builder' "$DF" && ok "stage 'builder'" || fail "Falta stage 'AS builder'"
    grep -qiE 'gcr\.io/distroless/nodejs' "$DF" && ok "usa distroless" || fail "El runtime debe usar gcr.io/distroless/nodejs20-debian12"
    grep -qiE '^COPY[[:space:]]+--from=builder' "$DF" && ok "COPY --from=builder" || fail "Falta 'COPY --from=builder'"
    grep -qiE '^USER[[:space:]]+nonroot' "$DF" && ok "USER nonroot" || fail "Falta 'USER nonroot'"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE '^CMD.*server\.js' "$DF" && ok "CMD ejecuta server.js" || fail "CMD debe ejecutar server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej04-01-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker run -d --rm --name "ej04-01-$$" -p 13030:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 3
    if curl -sf http://localhost:13030/ >/dev/null 2>&1; then ok "app distroless responde"; else fail "app distroless no responde"; fi
    # Verificar que NO hay shell (no se puede exec sh)
    if docker exec "ej04-01-$$" sh -c 'echo test' 2>/dev/null; then
      fail "la imagen tiene shell (no es distroless pura)"
    else
      ok "sin shell (distroless pura)"
    fi
    docker stop "ej04-01-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló (¿distroless no accesible?)"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
