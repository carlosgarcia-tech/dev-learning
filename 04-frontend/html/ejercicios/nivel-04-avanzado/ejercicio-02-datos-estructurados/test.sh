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

# Debe haber 2 bloques JSON-LD
JSONLD_COUNT=$(grep -o 'application/ld+json' "$ARCHIVO" | wc -l)
if [[ "$JSONLD_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan bloques JSON-LD, minimo 2, encontrados: $JSONLD_COUNT"
  exit 1
fi

check '"@type": "Article"' "Article type"
check '"headline"' "headline"
check '"author"' "author"
check '"datePublished"' "datePublished"

check '"@type": "BreadcrumbList"' "BreadcrumbList type"
check '"itemListElement"' "itemListElement"
check '"ListItem"' "ListItem"

# Al menos 2 position
POS_COUNT=$(grep -o '"position"' "$ARCHIVO" | wc -l)
if [[ "$POS_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "itemListElement necesita 2 position, encontrados: $POS_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
