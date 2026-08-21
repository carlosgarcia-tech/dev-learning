#!/bin/bash
# Test runner autocontenido para este ejercicio.
# No usa diff exacto contra un output.txt: los diffs exactos no son fiables
# para SQL con SERIAL/CURRENT_TIMESTAMP/RANDOM(). En su lugar corre init.sql
# y solucion.sql en una base de datos temporal y ejecuta comprobaciones
# estructurales (checks.sql).

set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="test_nivel_04_avanzado_02_stored_procedures"

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" postgres
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" postgres

echo "-> Ejecutando init.sql"
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f init.sql

echo "-> Ejecutando solucion.sql"
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f solucion.sql

if [ -f checks.sql ]; then
    echo "-> Ejecutando checks.sql"
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f checks.sql
fi

echo "✅ Ejercicio stored-procedures: init.sql + solucion.sql ejecutaron sin errores"
