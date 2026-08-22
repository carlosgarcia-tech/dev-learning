#!/usr/bin/env bash
set -euo pipefail

ARCHIVO="index.html"

if [[ ! -f "$ARCHIVO" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta el archivo $ARCHIVO"
  exit 1
fi

# Contar ocurrencias de h1
H1_COUNT=$(grep -o "<h1" "$ARCHIVO" | wc -l)
if [[ "$H1_COUNT" -ne 1 ]]; then
  echo "FAIL Tests fallaron"
  echo "Debe haber exactamente un <h1>, encontrados: $H1_COUNT"
  exit 1
fi

check() {
  if ! grep -qi "$1" "$ARCHIVO"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check "<h2" "al menos un h2"
check "<h3" "al menos un h3"
check "<p" "parrafos p"
check "<strong" "strong"
check "<em" "em"
check "<br" "salto de linea br"
check "<hr" "separador hr"

echo "OK Tests pasaron"
