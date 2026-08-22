#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Perfil.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Perfil.jsx"; exit 1; }
check() { grep -qi "$1" "Perfil.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useSWR' "useSWR"
check 'fetcher' "fetcher"
check 'isLoading\|loading' "isLoading"
check 'error' "error"
check 'export default' "export default"
echo "OK Tests pasaron"
