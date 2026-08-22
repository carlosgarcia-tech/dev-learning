#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "index.html" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta index.html"
  exit 1
fi

if [[ ! -f "style.css" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta style.css"
  exit 1
fi

check_css() {
  if ! grep -qi "$1" "style.css"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en style.css: $2"
    exit 1
  fi
}

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'rel="stylesheet"' "link al CSS"
check_html 'href="style.css"' "ruta del CSS"

check_css "^h1\|^p " "selector de etiqueta"
check_css "\.destacado" "selector de clase"
check_css "#cabecera" "selector de id"
check_css '\[type="email"\]\|\[type=.email.\]' "selector de atributo"
check_css ":hover" "pseudo-clase hover"
check_css ":first-child" "pseudo-clase first-child"
check_css ":nth-child" "pseudo-clase nth-child"

echo "OK Tests pasaron"
