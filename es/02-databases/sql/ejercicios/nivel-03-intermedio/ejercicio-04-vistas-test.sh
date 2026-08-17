#!/usr/bin/env bash
# Verificación: ejercicio-04-vistas
set -u
cd "$(dirname "$0")" || exit 1

DB="tmp.db"
SCHEMA="ejercicio-04-vistas-schema.sql"
SOL="ejercicio-04-vistas-solucion.sql"
CHECK="ejercicio-04-vistas-check.sql"
EXPECTED="ejercicio-04-vistas-expected.txt"

rm -f "$DB"
if ! sqlite3 -batch "$DB" < "$SCHEMA" 2>/dev/null; then
    echo "FAIL: no se pudo cargar el schema inicial"
    exit 1
fi

# Ejecutar la solución (DDL/DML)
sqlite3 -batch "$DB" < "$SOL" > /dev/null 2>&1

# Verificar el estado resultante
sqlite3 -batch -header -list -separator '|' "$DB" < "$CHECK" > tmp_actual.txt
if diff -q "$EXPECTED" tmp_actual.txt > /dev/null 2>&1; then
    echo "OK"
    rm -f "$DB" tmp_actual.txt
    exit 0
else
    echo "FAIL"
    echo "--- diff (esperado vs obtenido) ---"
    diff -u "$EXPECTED" tmp_actual.txt
    echo "--- obtenido ---"
    cat tmp_actual.txt
    rm -f "$DB" tmp_actual.txt
    exit 1
fi