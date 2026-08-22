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
check 'as="image"' "preload as image"
check 'rel="preconnect"' "preconnect"
check 'crossorigin' "crossorigin"
check 'display=swap' "display swap en fuente"
check 'loading="lazy"' "loading lazy"
check 'decoding="async"' "decoding async"
check 'fetchpriority="high"' "fetchpriority high"
check 'loading="eager"' "loading eager"
check 'width=' "width"
check 'height=' "height"

echo "OK Tests pasaron"
