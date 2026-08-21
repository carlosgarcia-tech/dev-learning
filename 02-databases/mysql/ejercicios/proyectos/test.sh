#!/bin/bash
# ============================================================
# Test runner del Proyecto Final: Sistema de Inventario y Ventas
# Ejecuta schema + datos + procedures + triggers + views en MySQL
# y verifica conteos y una vista de reporte.
# Si MySQL no está disponible, valida esquema + datos + vistas en SQLite.
# ============================================================
set -euo pipefail

DB_NAME="test_proyecto_inventario"
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

# Consultas de verificación (deterministas)
VERIFY_SQL="
SELECT COUNT(*) FROM categorias;
SELECT COUNT(*) FROM productos;
SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM ventas;
SELECT nombre FROM vw_stock_bajo ORDER BY id;
SELECT nombre, estado_stock FROM vw_inventario_actual WHERE estado_stock = 'Stock bajo' ORDER BY id;
"

if [ "$USE_MYSQL" -eq 1 ]; then
  echo "-> Creando base de datos temporal..."
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

  echo "-> Ejecutando schema.sql..."
  set +e
  mysql $MYSQL_ARGS "$DB_NAME" < schema.sql 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error en schema.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  echo "-> Ejecutando datos-iniciales.sql..."
  set +e
  mysql $MYSQL_ARGS "$DB_NAME" < datos-iniciales.sql 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error en datos-iniciales.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  echo "-> Ejecutando procedures.sql..."
  set +e
  mysql $MYSQL_ARGS "$DB_NAME" < procedures.sql 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error en procedures.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  echo "-> Ejecutando triggers.sql..."
  set +e
  mysql $MYSQL_ARGS "$DB_NAME" < triggers.sql 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error en triggers.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  echo "-> Ejecutando views.sql..."
  set +e
  mysql $MYSQL_ARGS "$DB_NAME" < views.sql 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error en views.sql)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  echo "-> Ejecutando verificaciones..."
  set +e
  mysql --batch --skip-column-names $MYSQL_ARGS "$DB_NAME" -e "$VERIFY_SQL" >"$TMP/actual" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error en verificaciones)"
    cat "$TMP/err" >&2
    mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    exit 1
  fi

  mysql $MYSQL_ARGS -e "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
else
  echo "-> MySQL no disponible. Usando SQLite3 para validación parcial..."
  if ! command -v sqlite3 >/dev/null 2>&1; then
    echo "FAIL Tests fallaron (no hay MySQL ni SQLite3 disponibles)"
    exit 1
  fi
  DBFILE="$TMP/db.sqlite"

  adapt() {
    sed -E \
      -e '/^DELIMITER/d' \
      -e 's/`//g' \
      -e 's/AUTO_INCREMENT/AUTOINCREMENT/g' \
      -e 's/INT UNSIGNED NOT NULL AUTOINCREMENT PRIMARY KEY/INTEGER PRIMARY KEY AUTOINCREMENT/g' \
      -e 's/INT NOT NULL AUTOINCREMENT PRIMARY KEY/INTEGER PRIMARY KEY AUTOINCREMENT/g' \
      -e 's/INT UNSIGNED NOT NULL AUTOINCREMENT/INTEGER NOT NULL/g' \
      -e 's/INT NOT NULL AUTOINCREMENT/INTEGER NOT NULL/g' \
      -e 's/INT UNSIGNED/INTEGER/g' \
      -e 's/DECIMAL\(([0-9]+),([0-9]+)\)/REAL/g' \
      -e 's/DATETIME/TEXT/g' \
      -e 's/TIMESTAMP/TEXT/g' \
      -e 's/TINYINT\(1\)/INTEGER/g' \
      -e 's/CREATE OR REPLACE VIEW/CREATE VIEW/g' \
      -e 's/ENUM\([^)]*\)/TEXT/g' \
      -e 's/UNIQUE KEY [a-zA-Z0-9_]+ \(/UNIQUE(/g' \
      -e 's/CONSTRAINT [a-zA-Z0-9_]+ FOREIGN KEY/FOREIGN KEY/g' \
      -e 's/ON DELETE RESTRICT//g' \
      -e 's/\)[[:space:]]*ENGINE=.*$/);/' \
      -e 's/\)[[:space:]]*DEFAULT .*$/);/' \
      -e 's/[[:space:]]+ON UPDATE CURRENT_TIMESTAMP//g' \
      -e 's/CHARACTER SET [a-zA-Z0-9_]+//g' \
      -e 's/COLLATE[[:space:]=][a-zA-Z0-9_]+//g' \
      -e "s/ COMMENT '[^']*'//g" \
      "$1"
  }

  # Solo adaptar schema, datos y views (omitir procedures y triggers)
  adapt schema.sql > "$TMP/schema_lite.sql"
  adapt datos-iniciales.sql > "$TMP/datos_lite.sql"
  adapt views.sql > "$TMP/views_lite.sql"

  set +e
  {
    printf '.nullvalue NULL\n.mode list\n.headers off\n.separator "\t"\nPRAGMA foreign_keys=ON;\n'
    cat "$TMP/schema_lite.sql"
    cat "$TMP/datos_lite.sql"
    cat "$TMP/views_lite.sql"
    printf '%s\n' "$VERIFY_SQL"
  } | sqlite3 "$DBFILE" > "$TMP/actual" 2>"$TMP/err"
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "FAIL Tests fallaron (error ejecutando en SQLite3; instala MySQL para validación completa)"
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
