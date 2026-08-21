#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -f "repo/primeras.txt" ] && [ "$(wc -l < repo/primeras.txt)" -eq 5 ] || { echo "FAIL: primeras.txt no tiene 5 líneas"; fail=1; }
grep -q "Linea 01" "repo/primeras.txt" || { echo "FAIL: primeras.txt no contiene 'Linea 01'"; fail=1; }
[ -f "repo/ultimas.txt" ] && [ "$(wc -l < repo/ultimas.txt)" -eq 3 ] || { echo "FAIL: ultimas.txt no tiene 3 líneas"; fail=1; }
grep -q "Linea 20" "repo/ultimas.txt" || { echo "FAIL: ultimas.txt no contiene 'Linea 20'"; fail=1; }
grep -q "src/main.py"  "repo/lista_py.txt" || { echo "FAIL: falta src/main.py en lista_py.txt"; fail=1; }
grep -q "src/utils.py" "repo/lista_py.txt" || { echo "FAIL: falta src/utils.py en lista_py.txt"; fail=1; }
[ "$(cat repo/cuenta_py.txt | tr -d ' ')" = "2" ] || { echo "FAIL: cuenta_py.txt no vale 2 (vale $(cat repo/cuenta_py.txt))"; fail=1; }
[ -s "repo/todos.txt" ] || { echo "FAIL: todos.txt vacío"; fail=1; }
grep -q "TODO" "repo/todos.txt" || { echo "FAIL: todos.txt no contiene TODO"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
