#!/usr/bin/env bash
# Test consulta-01: ingresos-mensuales
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 -batch -header -list -separator '|' "$DB" \
    < "$ROOT/consultas/consulta-01-ingresos-mensuales.sql" > "$DIR/actual.txt"

if diff -q "$DIR/expected-01.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   consulta-01-ingresos-mensuales"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL consulta-01-ingresos-mensuales"
diff "$DIR/expected-01.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1
