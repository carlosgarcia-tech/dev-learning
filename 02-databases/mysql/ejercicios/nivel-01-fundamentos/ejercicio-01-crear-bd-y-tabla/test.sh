#!/bin/bash
# Test runner autocontenido para ejercicios de MySQL.
# Usa MySQL si está disponible y responde; si no, usa SQLite3 como fallback.
# El nombre de la BD temporal se deriva del nombre de la carpeta del ejercicio.
set -euo pipefail

EJERCICIO="$(basename "$PWD")"
DB_NAME="test_$(printf '%s' "$EJERCICIO" | tr -cd 'a-zA-Z0-9')"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Args de conexión MySQL (opcionales vía entorno)
MYSQL_ARGS=""
if [ -n "${MYSQL_USER:-}" ];     then MYSQL_ARGS="$MYSQL_ARGS -u${MYSQL_USER}"; fi
if [ -n "${MYSQL_PASSWORD:-}" ]; then MYSQL_ARGS="$MYSQL_ARGS -p${MYSQL_PASSWORD}"; fi
if [ -n "${MYSQL_HOST:-}" ];     then MYSQL_ARGS="$MYSQL_ARGS -h${MYSQL_HOST}"; fi
if [ -n "${MYSQL_PORT:-}" ];     then MYSQL_ARGS="$MYSQL_ARGS -P${MYSQL_PORT}"; fi

# Normaliza salida para comparación entre motores:
#  - recorta espacios al final
#  - descarta líneas vacías
#  - convierte separador de columnas (tabulador) a '|'
#  - quita ceros decimales sobrantes (10.00 -> 10, 12.50 -> 12.5)
normalize() {
  sed -E 's/[[:space:]]+$//' \
  | grep -v '^[[:space:]]*$' \
  | sed -E 's/\t/|/g' \
  | sed -E -e ':a' -e 's/(\.[0-9]*)0$/\1/' -e 'ta' -e 's/\.$//'
}

# ¿MySQL disponible y respondiendo?
USE_MYSQL=0
if command -v mysql >/dev/null 2>&1; then
  if mysql $MYSQL_ARGS -e "SELECT 1" >/dev/null 2>&1; then
    USE_MYSQL=1
  fi
fi

if [ "$USE_MYSQL" -eq 1 ]; then
  # ---------- MySQL real ----------
  set +e
  mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null
  mysql $MYSQL_ARGS -e "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8mb4;" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (no se pudo crear la BD en MySQL)"
    cat "$TMP/err" >&2
    exit 1
  fi

  set +e
  mysql --batch --skip-column-names $MYSQL_ARGS "$DB_NAME" < schema.sql >"$TMP/schema_out" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error ejecutando schema.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  set +e
  mysql --batch --skip-column-names $MYSQL_ARGS "$DB_NAME" < solucion.sql >"$TMP/actual" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error ejecutando solucion.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  set +e
  mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null
  set -e
else
  # ---------- SQLite3 fallback ----------
  if ! command -v sqlite3 >/dev/null 2>&1; then
    echo "FAIL Tests fallaron (no hay MySQL ni SQLite3 disponibles)"
    exit 1
  fi
  DBFILE="$TMP/db.sqlite"

  adapt() {
    sed -E \
      -e '/-- MYSQL-ONLY START/,/-- MYSQL-ONLY END/d' \
      -e 's/`//g' \
      -e 's/AUTO_INCREMENT/AUTOINCREMENT/g' \
      -e 's/INT UNSIGNED NOT NULL AUTOINCREMENT PRIMARY KEY/INTEGER PRIMARY KEY AUTOINCREMENT/g' \
      -e 's/INT NOT NULL AUTOINCREMENT PRIMARY KEY/INTEGER PRIMARY KEY AUTOINCREMENT/g' \
      -e 's/INT UNSIGNED NOT NULL AUTOINCREMENT/INTEGER NOT NULL/g' \
      -e 's/INT NOT NULL AUTOINCREMENT/INTEGER NOT NULL/g' \
      -e 's/\)[[:space:]]*ENGINE=.*$/);/' \
      -e 's/\)[[:space:]]*DEFAULT .*$/);/' \
      -e 's/[[:space:]]+ON UPDATE CURRENT_TIMESTAMP//g' \
      -e 's/CHARACTER SET [a-zA-Z0-9_]+//g' \
      -e 's/COLLATE[[:space:]=][a-zA-Z0-9_]+//g' \
      -e 's/ENUM\([^)]*\)/TEXT/g' \
      -e "s/ COMMENT '[^']*'//g" \
      "$1"
  }

  adapt schema.sql  > "$TMP/schema_lite.sql"
  adapt solucion.sql > "$TMP/solucion_lite.sql"

  set +e
  {
    printf '.nullvalue NULL\n.mode list\n.headers off\n.separator "\t"\nPRAGMA foreign_keys=ON;\n'
    cat "$TMP/schema_lite.sql"
    cat "$TMP/solucion_lite.sql"
  } | sqlite3 "$DBFILE" > "$TMP/actual" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error ejecutando en SQLite3; instala MySQL para validar este ejercicio)"
    cat "$TMP/err" >&2
    exit 1
  fi
fi

# Comparar salida normalizada con la esperada
set +e
normalize < "$TMP/actual"  > "$TMP/actual_norm"
normalize < expected.txt   > "$TMP/expected_norm"
set -e

if diff -q "$TMP/actual_norm" "$TMP/expected_norm" >/dev/null 2>&1; then
  echo "OK Tests pasaron"
  exit 0
else
  echo "FAIL Tests fallaron"
  echo "--- Esperado ---"
  cat "$TMP/expected_norm"
  echo "--- Obtenido ---"
  cat "$TMP/actual_norm"
  exit 1
fi
