#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
for f in app/src/main.py app/src/utils.py app/tests/test_main.py app/tests/test_utils.py; do
  [ -s "$f" ] || { echo "FAIL: $f no existe o está vacío"; fail=1; }
  grep -q "archivo de" "$f" || { echo "FAIL: $f no contiene 'archivo de'"; fail=1; }
done
[ -f "app/docs/README.md" ] || { echo "FAIL: falta app/docs/README.md"; fail=1; }
grep -q "# Mi app" "app/docs/README.md" || { echo "FAIL: README.md sin '# Mi app'"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
