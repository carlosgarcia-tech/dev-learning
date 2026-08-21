#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cp "$HERE/solucion.sh" "$TMP/solucion.sh"
cd "$TMP"

out=$(bash solucion.sh 5 10 3 8)

fail=0
echo "$out" | grep -qx "n: 5"  || { echo "FAIL: falta 'n: 5'"; fail=1; }
echo "$out" | grep -qx "n: 10" || { echo "FAIL: falta 'n: 10'"; fail=1; }
echo "$out" | grep -qx "n: 3"  || { echo "FAIL: falta 'n: 3'"; fail=1; }
echo "$out" | grep -qx "n: 8"  || { echo "FAIL: falta 'n: 8'"; fail=1; }
[ "$(tr -d ' \n' < suma.txt)" = "26" ] || { echo "FAIL: suma.txt=$(cat suma.txt), esperado 26"; fail=1; }
[ "$(tr -d ' \n' < pares.txt)" = "2" ] || { echo "FAIL: pares.txt=$(cat pares.txt), esperado 2"; fail=1; }
[ "$(tr -d ' \n' < maximo.txt)" = "10" ] || { echo "FAIL: maximo.txt=$(cat maximo.txt), esperado 10"; fail=1; }
[ "$(wc -l < tabla.txt)" -eq 10 ] || { echo "FAIL: tabla.txt no tiene 10 líneas"; fail=1; }
head -n1 tabla.txt | grep -q "5 x 1 = 5" || { echo "FAIL: primera línea de tabla.txt incorrecta"; fail=1; }
tail -n1 tabla.txt | grep -q "5 x 10 = 50" || { echo "FAIL: última línea de tabla.txt incorrecta"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
