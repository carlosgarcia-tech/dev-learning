#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -L acceso.conf ] || { echo "FAIL: acceso.conf no es un enlace simbólico"; fail=1; }
[ "$(readlink acceso.conf)" = "src/config/app.conf" ] || { echo "FAIL: acceso.conf apunta a $(readlink acceso.conf)"; fail=1; }
[ -L link_origen.txt ] || { echo "FAIL: link_origen.txt no es simbólico"; fail=1; }
[ "$(readlink link_origen.txt)" = "src/original.txt" ] || { echo "FAIL: link_origen.txt apunta a $(readlink link_origen.txt)"; fail=1; }
[ -f duro.txt ] && [ ! -L duro.txt ] || { echo "FAIL: duro.txt no es un enlace duro (archivo regular)"; fail=1; }
[ "$(stat -c %i duro.txt)" = "$(stat -c %i src/original.txt)" ] || { echo "FAIL: duro.txt no comparte inodo con src/original.txt"; fail=1; }
grep -q "src/config/app.conf" verificacion.txt || { echo "FAIL: verificacion.txt no contiene el destino"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
