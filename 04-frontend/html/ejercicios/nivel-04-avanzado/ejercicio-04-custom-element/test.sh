#!/usr/bin/env bash
set -euo pipefail

ARCHIVO="index.html"

if [[ ! -f "$ARCHIVO" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta el archivo $ARCHIVO"
  exit 1
fi

check() {
  if ! grep -qi "$1" "$ARCHIVO"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check "HTMLElement" "clase que extiende HTMLElement"
check "customElements.define" "customElements.define"
check "saludo-personalizado" "nombre del custom element"
check "connectedCallback" "connectedCallback"
check "getAttribute" "getAttribute"
check '<saludo-personalizado' "uso del custom element"

echo "OK Tests pasaron"
