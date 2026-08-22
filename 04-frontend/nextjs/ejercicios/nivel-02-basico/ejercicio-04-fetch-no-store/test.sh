#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "page.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta page.jsx"; exit 1; }
check() { grep -qi "$1" "page.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'fetch' "fetch"
check "no-store" "cache no-store"
check 'async' "async"
check 'await' "await"
echo "OK Tests pasaron"
