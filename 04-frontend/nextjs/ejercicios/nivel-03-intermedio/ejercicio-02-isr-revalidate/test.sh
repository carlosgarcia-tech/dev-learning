#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "page.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta page.jsx"; exit 1; }
check() { grep -qi "$1" "page.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'revalidate' "revalidate"
check 'fetch' "fetch"
check 'async' "async"
echo "OK Tests pasaron"
