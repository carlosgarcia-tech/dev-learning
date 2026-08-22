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

check '<template' "template"
check 'id="tpl-fila"' "id del template"
check '<tr' "fila tr en template"
check 'id="cuerpo"' "tbody cuerpo"
check '<button' "boton"
check "cloneNode" "cloneNode"
check "appendChild" "appendChild"
check "addEventListener" "addEventListener"
check "content" "content del template"

echo "OK Tests pasaron"
