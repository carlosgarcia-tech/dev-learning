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

check 'rel="preload"' "preload"
check 'as="image"' "as image"
check 'fetchpriority="high"' "fetchpriority high"
check 'loading="eager"' "loading eager"
check "width=" "width en hero"
check "height=" "height en hero"
check 'min-height' "min-height"
check 'defer' "defer en script"

LAZY_COUNT=$(grep -o 'loading="lazy"' "$ARCHIVO" | wc -l)
if [[ "$LAZY_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan imagenes con loading lazy, minimo 2, encontradas: $LAZY_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
