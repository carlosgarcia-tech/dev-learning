#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "middleware.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta middleware.js"; exit 1; }
check() { grep -qi "$1" "middleware.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'NextResponse' "NextResponse"
check 'middleware' "middleware function"
check 'cookies' "cookies"
check 'token' "token"
check 'redirect' "redirect"
check 'matcher' "matcher"
echo "OK Tests pasaron"
