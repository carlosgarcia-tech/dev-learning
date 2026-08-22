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
check_file "sw.js"

check_in "index.html" 'rel="manifest"' "link manifest"
check_in "index.html" "serviceWorker.register" "registro SW"

check_in "sw.js" "install" "evento install"
check_in "sw.js" "caches.open" "caches.open"
check_in "sw.js" "addAll" "addAll"
check_in "sw.js" "activate" "evento activate"
check_in "sw.js" "caches.keys" "caches.keys"
check_in "sw.js" "caches.delete" "caches.delete"
check_in "sw.js" "fetch" "evento fetch"
check_in "sw.js" "caches.match" "caches.match"
check_in "sw.js" "offline" "fallback offline"

echo "OK Tests pasaron"
