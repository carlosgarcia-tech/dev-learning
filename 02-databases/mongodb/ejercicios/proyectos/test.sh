#!/usr/bin/env bash
# Validación del Proyecto Final: Blog NoSQL con MongoDB
# - Si mongosh + servidor MongoDB accesibles: ejecuta setup + solución contra blog_db.
# - Si no: valida la sintaxis JS de setup.js y solucion.js con node --check.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

SETUP="setup.js"
SOL="solucion.js"

fail() { echo "FAIL Tests fallaron"; exit 1; }

# Comprobar que existen los archivos del proyecto
if [[ ! -f "$SETUP" ]]; then echo "FAIL: falta $SETUP"; fail; fi
if [[ ! -f "$SOL" ]]; then echo "FAIL: falta $SOL"; fail; fi

# Camino A: mongosh disponible Y servidor MongoDB accesible
if command -v mongosh >/dev/null 2>&1 && timeout 3 mongosh --quiet --eval "db.runCommand({ping:1}).ok" >/dev/null 2>&1; then
  DB="blog_db"
  if ! mongosh --quiet --file "$SETUP" "$DB" >/dev/null 2>&1; then
    echo "FAIL: no se pudo aplicar el setup"
    fail
  fi
  if ! mongosh --quiet --file "$SOL" "$DB"; then
    echo "FAIL: la solución falló al ejecutarse"
    fail
  fi
  echo "OK Tests pasaron"
  exit 0
fi

# Camino B: sin servidor MongoDB -> validar sintaxis con node --check
if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: ni mongosh+servidor ni node disponibles"
  fail
fi

OK=1
for f in "$SETUP" "$SOL"; do
  if ! node --check "$f" 2>/dev/null; then
    echo "FAIL: $f no es JS válido"
    node --check "$f" || true
    OK=0
  fi
done

if [[ "$OK" -eq 1 ]]; then
  echo "OK Tests pasaron"
  exit 0
else
  fail
fi
