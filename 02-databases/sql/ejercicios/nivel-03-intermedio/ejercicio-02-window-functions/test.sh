#!/bin/bash
# Ejecuta schema.sql + solucion.sql sobre una base SQLite temporal
# y compara la salida con expected.txt

set -e
rm -f test.db
sqlite3 test.db < schema.sql
sqlite3 -header -column test.db < solucion.sql > output.txt

if diff -q output.txt expected.txt > /dev/null; then
    rm -f test.db output.txt
    echo "✅ Tests pasaron"
    exit 0
else
    echo "❌ Tests fallaron"
    diff output.txt expected.txt || true
    rm -f test.db output.txt
    exit 1
fi
