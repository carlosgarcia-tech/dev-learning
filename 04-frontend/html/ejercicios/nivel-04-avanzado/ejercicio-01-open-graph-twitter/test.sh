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

check 'property="og:type"' "og:type"
check 'property="og:title"' "og:title"
check 'property="og:description"' "og:description"
check 'property="og:image"' "og:image"
check 'property="og:url"' "og:url"
check 'property="og:site_name"' "og:site_name"

check 'name="twitter:card"' "twitter:card"
check 'name="twitter:title"' "twitter:title"
check 'name="twitter:description"' "twitter:description"
check 'name="twitter:image"' "twitter:image"

echo "OK Tests pasaron"
