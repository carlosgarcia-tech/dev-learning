#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "page.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta page.jsx"; exit 1; }
check() { grep -qi "$1" "page.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'params' "params"
check 'lang' "lang"
check 'es' "idioma es"
check 'en' "idioma en"
check 'export default' "export default"
echo "OK Tests pasaron"
