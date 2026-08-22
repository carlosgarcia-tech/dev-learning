#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Perfil.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Perfil.jsx"; exit 1; }
check() { grep -qi "$1" "Perfil.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useState' "useState"
check 'useEffect' "useEffect"
check 'fetch' "fetch"
check 'loading' "estado loading"
check 'error' "estado error"
check 'res.ok\|!res.ok' "res.ok"
check 'export default' "export default"
echo "OK Tests pasaron"
