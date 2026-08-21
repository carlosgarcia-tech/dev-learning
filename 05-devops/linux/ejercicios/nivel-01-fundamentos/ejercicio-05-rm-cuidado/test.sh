#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -f "tmp/importante.txt" ] || { echo "FAIL: importante.txt fue borrado"; fail=1; }
for f in debug.log error.log info.log; do
  [ ! -f "tmp/$f" ] || { echo "FAIL: tmp/$f no se borró"; fail=1; }
done
[ ! -d "tmp/basura" ] || { echo "FAIL: tmp/basura no se borró"; fail=1; }

# debe quedar solo importante.txt
restantes=$(ls -A tmp | wc -l)
[ "$restantes" -eq 1 ] || { echo "FAIL: quedan $restantes elementos (esperado 1)"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
