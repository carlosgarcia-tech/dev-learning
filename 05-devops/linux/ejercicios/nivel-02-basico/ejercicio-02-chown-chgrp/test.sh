#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh" 2>/dev/null || true   # chown puede no tener permiso; lo toleramos

fail=0
GRUPO=$(id -gn)
USUARIO=$(id -un)
[ "$(stat -c %G datos/compartido.txt)" = "$GRUPO" ] || { echo "FAIL: grupo de compartido.txt es $(stat -c %G datos/compartido.txt), esperado $GRUPO"; fail=1; }
[ "$(stat -c %U datos/local.txt)" = "$USUARIO" ] || { echo "FAIL: propietario de local.txt es $(stat -c %U datos/local.txt), esperado $USUARIO"; fail=1; }
[ "$(stat -c %G datos/local.txt)" = "$GRUPO" ] || { echo "FAIL: grupo de local.txt es $(stat -c %G datos/local.txt), esperado $GRUPO"; fail=1; }
for f in datos/carpeta datos/carpeta/a.txt datos/carpeta/b.txt; do
  [ "$(stat -c %U "$f")" = "$USUARIO" ] || { echo "FAIL: propietario de $f no es $USUARIO"; fail=1; }
done

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
