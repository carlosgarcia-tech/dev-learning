#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh" >/dev/null

fail=0
[ -f conexion.txt ] || { echo "FAIL: no se creó conexion.txt"; fail=1; }
contenido=$(cat conexion.txt 2>/dev/null || echo "")
case "$contenido" in
  CONEXION_OK|SIN_CONEXION) : ;;
  *) echo "FAIL: conexion.txt='$contenido', esperado CONEXION_OK o SIN_CONEXION"; fail=1;;
esac

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
