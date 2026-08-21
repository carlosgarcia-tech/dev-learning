#!/usr/bin/env bash
# Validación del ejercicio:
# - Si mongosh + servidor MongoDB accesibles: ejecuta setup + solución contra una base efímera.
# - Si no: valida la sintaxis JS de la solución con node --check.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

PREFIX="$(basename "$(pwd)")"
SETUP="${PREFIX}-setup.js"
SOL="${PREFIX}-solucion.js"

fail() { echo "FAIL Tests fallaron"; exit 1; }

# Comprobar que existen los archivos del ejercicio
if [[ ! -f "$SETUP" ]]; then echo "FAIL: falta $SETUP"; fail; fi
if [[ ! -f "$SOL" ]]; then echo "FAIL: falta $SOL"; fail; fi

# Camino A: mongosh disponible Y servidor MongoDB accesible
if command -v mongosh >/dev/null 2>&1 && timeout 3 mongosh --quiet --eval "db.runCommand({ping:1}).ok" >/dev/null 2>&1; then
  DB="ej_tests_$$"
  if ! mongosh --quiet --file "$SETUP" "$DB" >/dev/null 2>&1; then
    echo "FAIL: no se pudo aplicar el setup"
    fail
  fi
  if ! mongosh --quiet --file "$SOL" "$DB"; then
    echo "FAIL: la solución falló al ejecutarse"
    mongosh --quiet --eval "db.dropDatabase()" "$DB" >/dev/null 2>&1 || true
    fail
  fi
  mongosh --quiet --eval "db.dropDatabase()" "$DB" >/dev/null 2>&1 || true
  echo "OK Tests pasaron"
  exit 0
fi

# Camino B: sin servidor MongoDB -> validar sintaxis con node --check
if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: ni mongosh+servidor ni node disponibles"
  fail
fi

if node --check "$SOL" 2>/dev/null; then
  echo "OK Tests pasaron"
  exit 0
else
  echo "FAIL: la solución no es JS válido"
  node --check "$SOL" || true
  fail
fi
