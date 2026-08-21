#!/bin/bash
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="test_biblioteca_proyecto_final"

cd "$(dirname "$0")/.."

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" postgres
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" postgres

run() {
    echo "-> $1"
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f "$1"
}

run schema.sql
run datos.sql
run triggers/validar_stock.sql
run triggers/auditoria.sql
run functions/calcular_multa.sql
run functions/obtener_estadisticas_libro.sql
run procedures/registrar_prestamo.sql

echo "-> Prueba funcional: registrar un prestamo"
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c \
  "CALL registrar_prestamo(1, 1, CURRENT_TIMESTAMP);"

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c \
  "SELECT * FROM obtener_estadisticas_libro(1);"

echo "✅ Proyecto final: todo el flujo corrio sin errores"
