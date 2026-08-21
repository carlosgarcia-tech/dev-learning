#!/usr/bin/env bash
# test.sh — valida el ejercicio 02 nivel-05: buildx multi-arch
set -euo pipefail
cd "$(dirname "$0")"

DF="Dockerfile"
BS="build.sh"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$DF" ]] && ok "existe $DF" || fail "no existe $DF"
[[ -f "$BS" ]] && ok "existe build.sh" || fail "no existe build.sh"

if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    grep -qiE 'BUILDPLATFORM' "$DF" && ok "usa \$BUILDPLATFORM en builder" || fail "El builder debe usar --platform=\$BUILDPLATFORM"
    grep -qiE 'TARGETPLATFORM' "$DF" && ok "usa \$TARGETPLATFORM en runtime" || fail "El runtime debe usar --platform=\$TARGETPLATFORM"
    grep -qiE '^ARG[[:space:]]+TARGETPLATFORM' "$DF" && ok "ARG TARGETPLATFORM" || fail "Falta 'ARG TARGETPLATFORM'"
    grep -qiE 'AS[[:space:]]+builder' "$DF" && ok "stage builder" || fail "Falta stage 'AS builder'"
    grep -qiE '^COPY[[:space:]]+--from=builder' "$DF" && ok "COPY --from=builder" || fail "Falta 'COPY --from=builder'"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

if [[ -f "$BS" ]]; then
  grep -qiE 'buildx' "$BS" && ok "build.sh usa buildx" || fail "build.sh debe usar 'docker buildx build'"
  grep -qiE 'linux/amd64' "$BS" && grep -qiE 'linux/arm64' "$BS" && ok "build.sh define amd64+arm64" || fail "build.sh debe construir para linux/amd64,linux/arm64"
  grep -qiE '\-t[[:space:]]+\S+' "$BS" && ok "build.sh etiqueta la imagen" || fail "build.sh debe usar -t para etiquetar"
  # build.sh debe ser ejecutable en sintaxis (bash -n)
  if bash -n "$BS"; then ok "build.sh sintaxis válida"; else fail "build.sh tiene errores de sintaxis"; fi
fi

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1 && docker buildx version >/dev/null 2>&1; then
  IMG="ej05-02-test:$$"
  # Build solo para amd64 (multi-arch completo requiere --push o QEMU; testeamos build local)
  if docker buildx build --platform linux/amd64 --load -t "$IMG" . >/dev/null 2>&1; then
    ok "docker buildx build (amd64) OK"
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker buildx build falló"; fi
else MSGS+=("INFO - docker buildx no disponible, se omite build"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
