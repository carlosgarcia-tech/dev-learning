#!/usr/bin/env bash
# Test consulta-14: trigger de inventario
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 "$DB" < "$ROOT/consultas/consulta-14-trigger-inventario.sql"
sqlite3 -batch -header -list -separator '|' "$DB" < "$DIR/check-14.sql" > "$DIR/actual.txt"

if diff -q "$DIR/expected-14.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   consulta-14-trigger-inventario"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL consulta-14-trigger-inventario"
diff "$DIR/expected-14.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1