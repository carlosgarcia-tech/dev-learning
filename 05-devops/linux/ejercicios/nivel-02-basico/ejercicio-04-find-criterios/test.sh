#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
grep -qx '\.' archivos/por_tipo_dir.txt || { echo "FAIL: por_tipo_dir.txt no contiene '.'"; fail=1; }
[ -s "archivos/por_tipo_archivo.txt" ] || { echo "FAIL: por_tipo_archivo.txt vacío"; fail=1; }
[ -s "archivos/por_nombre_bak.txt" ] || { echo "FAIL: por_nombre_bak.txt vacío"; fail=1; }
grep -q "grande.log" archivos/por_tamano.txt || { echo "FAIL: grande.log no está en por_tamano.txt"; fail=1; }
grep -q "vacio.txt" archivos/vacios.txt || { echo "FAIL: vacio.txt no está en vacios.txt"; fail=1; }
[ -x "archivos/script.sh" ] || { echo "FAIL: script.sh no es ejecutable"; fail=1; }
[ -s "archivos/ejecutar_chmod.txt" ] || { echo "FAIL: ejecutar_chmod.txt vacío"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
