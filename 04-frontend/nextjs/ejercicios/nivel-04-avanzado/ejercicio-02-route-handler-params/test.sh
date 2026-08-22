#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "route.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta route.js"; exit 1; }
check() { grep -qi "$1" "route.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'GET' "GET"
check 'DELETE' "DELETE"
check 'params' "params"
check 'id' "id"
echo "OK Tests pasaron"
