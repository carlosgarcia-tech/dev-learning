#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "loading.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta loading.jsx"; exit 1; }
check() { grep -qi "$1" "loading.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'export default' "export default"
check 'Cargando\|Loading' "mensaje de carga"
echo "OK Tests pasaron"
