#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh" >/dev/null

fail=0
[ -f "proyectos/web/tests/marcador.txt" ] || { echo "FAIL: no se creó marcador.txt en proyectos/web/tests"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"
  exit 0
else
  echo "FAIL Tests fallaron"
  exit 1
fi
