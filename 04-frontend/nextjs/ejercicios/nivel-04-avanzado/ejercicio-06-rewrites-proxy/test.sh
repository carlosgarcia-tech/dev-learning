#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "next.config.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta next.config.js"; exit 1; }
check() { grep -qi "$1" "next.config.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'rewrites' "rewrites"
check 'source' "source"
check 'destination' "destination"
check 'module.exports' "module.exports"
echo "OK Tests pasaron"
