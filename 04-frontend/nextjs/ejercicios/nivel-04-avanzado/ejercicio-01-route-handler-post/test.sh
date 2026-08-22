#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "route.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta route.js"; exit 1; }
check() { grep -qi "$1" "route.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'POST' "POST"
check 'request.json\|request\.json' "request.json()"
check 'Response.json' "Response.json"
check 'async' "async"
echo "OK Tests pasaron"
