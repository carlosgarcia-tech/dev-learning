#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh" >/dev/null

fail=0
[ "$(tr -d ' ' < total_lineas.txt)" = "100" ] || { echo "FAIL: total_lineas.txt = $(cat total_lineas.txt), esperado 100"; fail=1; }
[ "$(tr -d ' ' < suma.txt)" = "5050" ] || { echo "FAIL: suma.txt = $(cat suma.txt), esperado 5050"; fail=1; }
[ "$(tr -d ' ' < pares.txt)" = "100" ] || { echo "FAIL: pares.txt = $(cat pares.txt), esperado 100"; fail=1; }
grep -q "Procesando datos" log_tee.txt || { echo "FAIL: log_tee.txt sin el mensaje"; fail=1; }
[ -s errores_y_salida.txt ] || { echo "FAIL: errores_y_salida.txt vacío"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
