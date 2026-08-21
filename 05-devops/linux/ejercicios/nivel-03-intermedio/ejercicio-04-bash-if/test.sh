#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cp "$HERE/solucion.sh" "$TMP/solucion.sh"
cd "$TMP"

fail=0
check() {
  local args="$1"; local expected_out="$2"; local expected_code="$3"; local label="$4"
  out=$(bash solucion.sh $args 2>/dev/null) ; code=$?
  [ "$out" = "$expected_out" ] || { echo "FAIL [$label]: salida='$out', esperada='$expected_out'"; fail=1; }
  [ "$code" = "$expected_code" ] || { echo "FAIL [$label]: código=$code, esperado=$expected_code"; fail=1; }
}

check "95" "Excelente" 0 "95-excelente"
check "70" "Aprobado"  0 "70-aprobado"
check "50" "Reprobado" 0 "50-reprobado"
check "abc" "Error: nota invalida" 1 "abc-invalido"
check "100" "Excelente" 0 "100-excelente"
check "0"   "Reprobado" 0 "0-reprobado"

# Sin argumentos: salida empieza por Uso: y código 2
out=$(bash solucion.sh 2>/dev/null) ; code=$?
case "$out" in Uso:*) : ;; *) echo "FAIL [sin-args]: salida='$out', esperada que empiece por 'Uso:'"; fail=1;; esac
[ "$code" = "2" ] || { echo "FAIL [sin-args]: código=$code, esperado=2"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
