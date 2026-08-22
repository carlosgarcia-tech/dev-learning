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

check 'lang="es"' "html lang es"
check 'class="skip"' "skip link"
check '#contenido' "href contenido"
check '<main' "main"
check 'id="contenido"' "id contenido"
check 'aria-current="page"' "aria-current page"
check 'aria-label=' "aria-label"
check 'aria-hidden="true"' "aria-hidden true"
check '<svg' "svg icono"

echo "OK Tests pasaron"
