#!/usr/bin/env bash
# test.sh — valida el ejercicio 02: copiar y ejecutar un script
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
    grep -qiE '^FROM[[:space:]]+alpine:3\.20' "$DF" && ok "FROM alpine:3.20" || fail "Falta FROM alpine:3.20"
    grep -qiE '^WORKDIR[[:space:]]+/app' "$DF" && ok "WORKDIR /app" || fail "Falta WORKDIR /app"
    grep -qiE '^COPY[[:space:]].*hello\.sh' "$DF" && ok "COPY hello.sh" || fail "Falta COPY hello.sh"
    grep -qiE '^RUN[[:space:]].*chmod.*\+x' "$DF" && ok "RUN chmod +x" || fail "Falta RUN chmod +x"
    grep -qiE '^ENTRYPOINT[[:space:]]+\[' "$DF" && ok "ENTRYPOINT exec form" || fail "ENTRYPOINT debe ir en forma exec"
    grep -qiE 'hello\.sh' "$DF" && grep -qiE '^ENTRYPOINT' "$DF" && ok "ENTRYPOINT ejecuta hello.sh" || fail "ENTRYPOINT debe ejecutar hello.sh"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No uses :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"
[[ -f app/hello.sh ]] && ok "existe app/hello.sh" || fail "falta app/hello.sh"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej02-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    OUT="$(docker run --rm "$IMG" 2>/dev/null || true)"
    [[ "$OUT" == *"Hola desde el script"* ]] && ok "docker run imprime mensaje" || fail "docker run no imprime el mensaje"
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
