#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

check_file() {
  if [[ ! -f "$1" ]]; then
    echo "FAIL Tests fallaron"
    echo "Falta el archivo $1"
    exit 1
  fi
}

check_in() {
  local archivo="$1" pat="$2" msg="$3"
  if ! grep -qi "$pat" "$archivo"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en $archivo: $msg"
    exit 1
  fi
}

check_file "index.html"
check_file "manifest.json"
check_file "sw.js"

check_in "index.html" 'rel="manifest"' "link manifest"
check_in "index.html" "serviceWorker.register" "registro del SW"
check_in "index.html" "addEventListener" "addEventListener"

check_in "manifest.json" '"name"' "name"
check_in "manifest.json" '"short_name"' "short_name"
check_in "manifest.json" '"start_url"' "start_url"
check_in "manifest.json" '"display"' "display"
check_in "manifest.json" '"icons"' "icons"

check_in "sw.js" "install" "evento install"
check_in "sw.js" "caches.open" "caches.open"
check_in "sw.js" "fetch" "evento fetch"

echo "OK Tests pasaron"
