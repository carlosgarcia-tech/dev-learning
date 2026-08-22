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
check "attachShadow" "attachShadow"
check "mode: 'open'" "mode open"
check "customElements.define" "customElements.define"
check "tarjeta-producto" "nombre del custom element"
check '<tarjeta-producto' "uso del componente"
check '<slot name="titulo"' "slot titulo"
check '<slot name="precio"' "slot precio"

# Estilos dentro del shadow DOM
if ! grep -qi "<style>" "$ARCHIVO"; then
  echo "FAIL Tests fallaron"
  echo "Falta style dentro del shadow DOM"
  exit 1
fi

echo "OK Tests pasaron"
