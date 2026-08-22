#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "sitemap.js" ]] && { echo "FAIL Tests fallaron"; echo "Falta sitemap.js"; exit 1; }
check() { grep -qi "$1" "sitemap.js" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'sitemap' "sitemap"
check 'url' "url"
check 'lastModified' "lastModified"
check 'export default' "export default"
echo "OK Tests pasaron"
