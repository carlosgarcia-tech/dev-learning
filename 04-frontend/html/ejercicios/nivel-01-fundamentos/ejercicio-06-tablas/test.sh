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

check "<table" "tabla"
check "<caption" "caption"
check "<thead" "thead"
check "<tbody" "tbody"
check 'scope="col"' "scope col"
check 'scope="row"' "scope row"

# Al menos 3 filas en tbody (contamos <tr> totales, 1 es thead, >=4 en total)
TR_COUNT=$(grep -o "<tr" "$ARCHIVO" | wc -l)
if [[ "$TR_COUNT" -lt 4 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas al menos 3 filas de datos (4 <tr> contando thead), encontrados: $TR_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
