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

check "<picture" "picture"
check 'type="image/avif"' "source avif"
check 'type="image/webp"' "source webp"
check "<img" "img fallback"
check 'srcset=' "srcset"
check 'sizes=' "sizes"
check 'loading="lazy"' "loading lazy"

# Al menos 2 source
SOURCE_COUNT=$(grep -o '<source' "$ARCHIVO" | wc -l)
if [[ "$SOURCE_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan source en picture, minimo 2, encontrados: $SOURCE_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
