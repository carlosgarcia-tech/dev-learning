#!/usr/bin/env bash
# Verificación: ejercicio-06-like-y-filtros
set -u
cd "$(dirname "$0")" || exit 1

DB="tmp.db"
SCHEMA="ejercicio-06-like-y-filtros-schema.sql"
SOL="ejercicio-06-like-y-filtros-solucion.sql"
EXPECTED="ejercicio-06-like-y-filtros-expected.txt"

rm -f "$DB"
if ! sqlite3 -batch "$DB" < "$SCHEMA" 2>/dev/null; then
    echo "FAIL: no se pudo cargar el schema inicial"
    exit 1
fi

sqlite3 -batch -header -list -separator '|' "$DB" < "$SOL" > tmp_actual.txt
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