#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "useContador.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta useContador.js"; exit 1; }
check() { grep -qi "$1" "useContador.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'create' "create de zustand"
check 'valor' "estado valor"
check 'incrementar' "accion incrementar"
check 'reset' "accion reset"
check 'set' "set"
check 'export' "export"
echo "OK Tests pasaron"
