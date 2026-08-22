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

check "<title>" "title"
check 'name="description"' "meta description"
check 'rel="canonical"' "canonical"
check 'name="robots"' "robots"
check "index, follow" "robots content"

OG_COUNT=$(grep -o 'property="og:' "$ARCHIVO" | wc -l)
if [[ "$OG_COUNT" -lt 4 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan etiquetas Open Graph, minimo 4, encontradas: $OG_COUNT"
  exit 1
fi

# Validar longitud de description
DESC=$(grep -o 'name="description" content="[^"]*"' "$ARCHIVO" | sed 's/.*content="//;s/"$//')
DESC_LEN=${#DESC}
if [[ "$DESC_LEN" -lt 50 ]]; then
  echo "FAIL Tests fallaron"
  echo "Description demasiado corta: $DESC_LEN caracteres (minimo 50)"
  exit 1
fi

echo "OK Tests pasaron"
