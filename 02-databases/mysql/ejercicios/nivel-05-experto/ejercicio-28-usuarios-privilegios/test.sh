#!/bin/bash
# Test runner autocontenido para ejercicios de MySQL.
# La creación de usuarios y GRANT requiere MySQL con privilegios.
# El test ejecuta las sentencias DCL y luego la consulta de verificación.
# En SQLite (fallback), solo ejecuta la consulta autónoma final.
set -euo pipefail

EJERCICIO="$(basename "$PWD")"
DB_NAME="test_$(printf '%s' "$EJERCICIO" | tr -cd 'a-zA-Z0-9')"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

MYSQL_ARGS=""
if [ -n "${MYSQL_USER:-}" ];     then MYSQL_ARGS="$MYSQL_ARGS -u${MYSQL_USER}"; fi
if [ -n "${MYSQL_PASSWORD:-}" ]; then MYSQL_ARGS="$MYSQL_ARGS -p${MYSQL_PASSWORD}"; fi
if [ -n "${MYSQL_HOST:-}" ];     then MYSQL_ARGS="$MYSQL_ARGS -h${MYSQL_HOST}"; fi
if [ -n "${MYSQL_PORT:-}" ];     then MYSQL_ARGS="$MYSQL_ARGS -P${MYSQL_PORT}"; fi

normalize() {
  sed -E 's/[[:space:]]+$//' \
  | grep -v '^[[:space:]]*$' \
  | sed -E 's/\t/|/g' \
  | sed -E -e ':a' -e 's/(\.[0-9]*)0$/\1/' -e 'ta' -e 's/\.$//'
}

USE_MYSQL=0
if command -v mysql >/dev/null 2>&1; then
  if mysql $MYSQL_ARGS -e "SELECT 1" >/dev/null 2>&1; then
    USE_MYSQL=1
  fi
fi

if [ "$USE_MYSQL" -eq 1 ]; then
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
  # Ejecutar solucion.sql completa (CREATE USER, GRANT, SELECT)
  mysql --batch --skip-column-names $MYSQL_ARGS "$DB_NAME" < solucion.sql >"$TMP/actual_raw" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error ejecutando solucion.sql)"
    cat "$TMP/err" >&2
    # Limpiar usuarios creados (puede que hayan quedado)
    mysql $MYSQL_ARGS -e "DROP USER IF EXISTS 'app_reader'@'localhost';" 2>/dev/null || true
    mysql $MYSQL_ARGS -e "DROP USER IF EXISTS 'app_writer'@'localhost';" 2>/dev/null || true
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi
  # Limpiar usuarios creados
  mysql $MYSQL_ARGS -e "DROP USER IF EXISTS 'app_reader'@'localhost';" 2>/dev/null || true
  mysql $MYSQL_ARGS -e "DROP USER IF EXISTS 'app_writer'@'localhost';" 2>/dev/null || true
  mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
  # La salida es solo la última línea (el SELECT de verificación)
  tail -1 "$TMP/actual_raw" > "$TMP/actual"
else
  if ! command -v sqlite3 >/dev/null 2>&1; then
    echo "FAIL Tests fallaron (no hay MySQL ni SQLite3 disponibles)"
    exit 1
  fi
  DBFILE="$TMP/db.sqlite"
  # En SQLite, ejecutar solo la consulta autónoma final (CREATE USER/GRANT no existen)
  grep 'SELECT' solucion.sql > "$TMP/executable.sql"
  set +e
  {
    printf '.nullvalue NULL\n.mode list\n.headers off\n.separator "\t"\n'
    cat "$TMP/executable.sql"
  } | sqlite3 "$DBFILE" > "$TMP/actual" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error ejecutando en SQLite3; instala MySQL para validar este ejercicio)"
    cat "$TMP/err" >&2
    exit 1
  fi
fi

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
