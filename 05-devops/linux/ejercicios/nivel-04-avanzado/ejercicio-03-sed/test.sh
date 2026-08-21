#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
# guardamos hash del original para verificar que no se modifica
orig_md5=$(md5sum "$TMP/config.conf" | awk '{print $1}')
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -s cambiado.txt ] || { echo "FAIL: cambiado.txt vacío"; fail=1; }
grep -q "0.0.0.0" cambiado.txt || { echo "FAIL: cambiado.txt no contiene 0.0.0.0"; fail=1; }
if grep -q "localhost" cambiado.txt; then echo "FAIL: cambiado.txt aún contiene localhost"; fail=1; fi
grep -q "false" cambiado.txt || { echo "FAIL: cambiado.txt no contiene false"; fail=1; }
if grep -q "true" cambiado.txt; then echo "FAIL: cambiado.txt aún contiene true"; fail=1; fi

[ -s mayus.txt ] || { echo "FAIL: mayus.txt vacío"; fail=1; }
if grep -q '[a-z]' mayus.txt; then echo "FAIL: mayus.txt contiene minúsculas"; fail=1; fi

[ -s sin_comentarios.txt ] || { echo "FAIL: sin_comentarios.txt vacío"; fail=1; }
if grep -q '^#' sin_comentarios.txt; then echo "FAIL: sin_comentarios.txt tiene líneas con #"; fail=1; fi

# el original no debe modificarse
final_md5=$(md5sum config.conf | awk '{print $1}')
[ "$orig_md5" = "$final_md5" ] || { echo "FAIL: config.conf original fue modificado"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
