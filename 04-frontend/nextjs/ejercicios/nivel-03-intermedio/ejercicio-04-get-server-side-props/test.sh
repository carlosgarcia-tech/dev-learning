#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "pagina.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta pagina.js"; exit 1; }
check() { grep -qi "$1" "pagina.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'getServerSideProps' "getServerSideProps"
check 'async' "async"
check 'props' "props"
check 'export default' "export default"
echo "OK Tests pasaron"
