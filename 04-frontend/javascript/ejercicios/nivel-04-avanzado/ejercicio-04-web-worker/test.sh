#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

check_file() {
  if [[ ! -f "$1" ]]; then
    echo "FAIL Tests fallaron"
    echo "Falta $1"
    exit 1
  fi
}

check_file "index.html"
check_file "script.js"
check_file "worker.js"

check_js() {
  if ! grep -qi "$1" "script.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en script.js: $2"
    exit 1
  fi
}

check_worker() {
  if ! grep -qi "$1" "worker.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en worker.js: $2"
    exit 1
  fi
}

check_js 'Worker' "new Worker"
check_js 'postMessage' "postMessage"
check_js 'onmessage' "onmessage"

check_worker 'self.onmessage' "self.onmessage en worker"
check_worker 'self.postMessage' "self.postMessage en worker"

echo "OK Tests pasaron"
