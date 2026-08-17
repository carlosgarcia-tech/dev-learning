#!/usr/bin/env bash
# Test de estructura del esquema
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 -batch -header -list -separator '|' "$DB" < "$DIR/check-estructura.sql" > "$DIR/actual.txt"

if diff -q "$DIR/expected-estructura.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   estructura-del-esquema"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL estructura-del-esquema"
diff "$DIR/expected-estructura.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1