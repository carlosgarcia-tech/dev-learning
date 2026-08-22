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

check "HTMLElement" "clase HTMLElement"
check "observedAttributes" "observedAttributes"
check "'valor'" "atributo valor observado"
check "connectedCallback" "connectedCallback"
check "attributeChangedCallback" "attributeChangedCallback"
check "disconnectedCallback" "disconnectedCallback"
check "customElements.define" "customElements.define"
check "contador-elemento" "nombre del custom element"
check "addEventListener" "addEventListener"
check "removeEventListener" "removeEventListener"
check '<contador-elemento' "uso del componente"

echo "OK Tests pasaron"
