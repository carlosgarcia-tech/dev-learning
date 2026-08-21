#!/usr/bin/env bash
# test.sh — valida el ejercicio 06 nivel-05: imagen mínima scratch
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
    [[ "$N_FROM" -ge 2 ]] && ok "multi-stage ($N_FROM FROM)" || fail "Se necesitan 2 FROM (builder + scratch)"
    grep -qiE 'AS[[:space:]]+builder' "$DF" && ok "stage 'builder'" || fail "Falta stage 'AS builder'"
    grep -qiE 'golang:1\.23-alpine' "$DF" && ok "builder usa golang:1.23-alpine" || fail "El builder debe usar golang:1.23-alpine"
    grep -qiE 'CGO_ENABLED=0' "$DF" && ok "CGO_ENABLED=0" || fail "Falta 'CGO_ENABLED=0' (binario estático)"
    grep -qiE 'ldflags' "$DF" && ok "ldflags presente" || fail "Falta '-ldflags=\"-s -w\"'"
    grep -qiE '\-s[[:space:]]*-w|-s -w' "$DF" && ok "strip -s -w" || fail "Usa '-ldflags=\"-s -w\"' para strip"
    grep -qiE '^FROM[[:space:]]+scratch' "$DF" && ok "runtime FROM scratch" || fail "El runtime debe usar 'FROM scratch'"
    grep -qiE '^COPY[[:space:]]+--from=builder' "$DF" && ok "COPY --from=builder" || fail "Falta 'COPY --from=builder'"
    grep -qiE '^ENTRYPOINT[[:space:]]+\[' "$DF" && ok "ENTRYPOINT exec form" || fail "ENTRYPOINT en forma exec"
    grep -qiE '"/app"' "$DF" && ok "ENTRYPOINT /app" || fail "ENTRYPOINT debe ser [\"/app\"]"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"
[[ -f app/main.go ]] && ok "existe app/main.go" || fail "falta app/main.go"
[[ -f app/go.mod ]] && ok "existe app/go.mod" || fail "falta app/go.mod"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej05-06-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    # Verificar que la imagen es muy pequeña (scratch + binario Go estático debería ser < 20 MB)
    SIZE=$(docker image inspect "$IMG" --format '{{.Size}}' 2>/dev/null || echo 0)
    if [[ "$SIZE" -gt 0 && "$SIZE" -lt 20000000 ]]; then
      ok "imagen pequeña (${SIZE} bytes < 20 MB)"
    else
      fail "imagen demasiado grande (${SIZE} bytes, esperado < 20 MB)"
    fi
    # Verificar que NO hay shell (scratch puro)
    if docker run --rm "$IMG" /bin/sh 2>/dev/null; then
      fail "la imagen tiene shell (no es scratch puro)"
    else
      ok "sin shell (scratch puro)"
    fi
    # Probar que el binario funciona
    docker run -d --rm --name "ej05-06-$$" -p 13040:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    if curl -sf http://localhost:13040/ >/dev/null 2>&1; then ok "app scratch responde"; else fail "app scratch no responde"; fi
    docker stop "ej05-06-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
