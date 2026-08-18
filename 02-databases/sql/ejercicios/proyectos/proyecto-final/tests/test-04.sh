#!/usr/bin/env bash
# Test consulta-04: ticket-medio-cliente
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 -batch -header -list -separator '|' "$DB" \
    < "$ROOT/consultas/consulta-04-ticket-medio-cliente.sql" > "$DIR/actual.txt"

if diff -q "$DIR/expected-04.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   consulta-04-ticket-medio-cliente"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL consulta-04-ticket-medio-cliente"
diff "$DIR/expected-04.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1
