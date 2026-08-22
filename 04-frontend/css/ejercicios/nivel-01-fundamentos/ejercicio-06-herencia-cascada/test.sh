#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

check_file() {
  if [[ ! -f "$1" ]]; then
    echo "FAIL Tests fallaron"
    echo "Falta $1"
    exit 1
  fi
}

check_file "index.html"
check_file "style.css"

check_css() {
  if ! grep -qi "$1" "style.css"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en style.css: $2"
    exit 1
  fi
}

check_css "font-family" "font-family en body"
check_css "color" "color en body"

# Dos reglas para p
P_COUNT=$(grep -cE '^p[ {]|^p$' "style.css")
if [[ "$P_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 2 reglas para p (cascada), encontradas: $P_COUNT"
  exit 1
fi

check_css "inherit\|initial\|unset" "inherit, initial o unset"

echo "OK Tests pasaron"
