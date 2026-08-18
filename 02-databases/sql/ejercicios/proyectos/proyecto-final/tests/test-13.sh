#!/usr/bin/env bash
# Test consulta-13: crear índices
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 "$DB" < "$ROOT/consultas/consulta-13-crear-indices.sql"
sqlite3 -batch -header -list -separator '|' "$DB" \
    "SELECT name FROM sqlite_master WHERE type='index' AND name LIKE 'idx_%' ORDER BY name;" \
    > "$DIR/actual.txt"

if diff -q "$DIR/expected-13.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   consulta-13-crear-indices"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL consulta-13-crear-indices"
diff "$DIR/expected-13.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1