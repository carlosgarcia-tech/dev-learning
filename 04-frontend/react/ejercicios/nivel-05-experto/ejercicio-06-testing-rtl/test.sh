#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ ! -f "Contador.test.jsx" && ! -f "Contador.test.js" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Contador.test.jsx (o .js)"
  exit 1
fi
ARCHIVO=$(ls Contador.test.jsx Contador.test.js 2>/dev/null | head -1)
check() { grep -qi "$1" "$ARCHIVO" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'render' "render"
check 'screen' "screen"
check 'userEvent' "userEvent"
check 'click' "click"
check 'expect' "expect"
echo "OK Tests pasaron"
