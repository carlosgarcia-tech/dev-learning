#!/usr/bin/env bash
# Test de integridad de los datos
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 -batch -header -list -separator '|' "$DB" < "$DIR/check-datos.sql" > "$DIR/actual.txt"

if diff -q "$DIR/expected-datos.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   integridad-de-los-datos"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL integridad-de-los-datos"
diff "$DIR/expected-datos.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1