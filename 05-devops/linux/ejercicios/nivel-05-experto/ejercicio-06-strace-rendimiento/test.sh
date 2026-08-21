#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
for f in syscalls_cat.txt resumen_syscalls.txt archivos_abiertos.txt comparacion.txt; do
  [ -s "$f" ] || { echo "FAIL: $f vacío o no existe"; fail=1; }
done
grep -qi "strace" comparacion.txt || { echo "FAIL: comparacion.txt no menciona strace"; fail=1; }

# Si strace está disponible, syscalls_cat debería contener openat
if command -v strace >/dev/null 2>&1; then
  if ! grep -q "strace no disponible" syscalls_cat.txt; then
    grep -qi "openat\|open" syscalls_cat.txt || { echo "FAIL: syscalls_cat.txt no contiene llamadas openat/open"; fail=1; }
  fi
fi

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
