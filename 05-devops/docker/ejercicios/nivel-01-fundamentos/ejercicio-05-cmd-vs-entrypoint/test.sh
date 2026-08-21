#!/usr/bin/env bash
# test.sh — valida el ejercicio 05: CMD vs ENTRYPOINT
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
    grep -qiE '^ENTRYPOINT[[:space:]]+\[' "$DF" && ok "ENTRYPOINT exec form" || fail "ENTRYPOINT debe ir en forma exec"
    grep -qiE '^ENTRYPOINT[[:space:]].*echo' "$DF" && ok "ENTRYPOINT usa echo" || fail "ENTRYPOINT debe usar echo"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD debe ir en forma exec"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
    # Verifica el orden: ENTRYPOINT antes que CMD
    EP_LINE=$(grep -nE '^ENTRYPOINT' "$DF" | head -1 | cut -d: -f1)
    CMD_LINE=$(grep -nE '^CMD' "$DF" | head -1 | cut -d: -f1)
    if [[ -n "$EP_LINE" && -n "$CMD_LINE" && "$EP_LINE" -lt "$CMD_LINE" ]]; then
      ok "ENTRYPOINT aparece antes que CMD"
    else
      fail "ENTRYPOINT debe ir antes que CMD"
    fi
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej05-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    OUT1="$(docker run --rm "$IMG" 2>/dev/null || true)"
    [[ "$OUT1" == *"Hola Docker"* ]] && ok "sin args imprime 'Hola Docker'" || fail "sin args no imprime 'Hola Docker' (salida: $OUT1)"
    OUT2="$(docker run --rm "$IMG" Mundo 2>/dev/null || true)"
    [[ "$OUT2" == *"Hola Mundo"* ]] && ok "con arg imprime 'Hola Mundo'" || fail "con arg no imprime 'Hola Mundo' (salida: $OUT2)"
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
