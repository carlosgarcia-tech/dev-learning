#!/usr/bin/env bash
# Test consulta-15: transacción de compra completa
set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$DIR")"
DB="$(mktemp -t proyecto_final.XXXXXX.db)"
trap 'rm -f "$DB"' EXIT

cat "$ROOT/schema.sql" "$ROOT/datos.sql" | sqlite3 "$DB"
sqlite3 "$DB" < "$ROOT/consultas/consulta-15-transaccion-compra.sql"

sqlite3 -batch -header -list -separator '|' "$DB" < "$DIR/check-15-success.sql" > "$DIR/actual.txt"
if ! diff -q "$DIR/expected-15-success.txt" "$DIR/actual.txt" > /dev/null; then
    echo "FAIL consulta-15-transaccion-compra (estado tras COMMIT)"
    diff "$DIR/expected-15-success.txt" "$DIR/actual.txt"
    rm -f "$DIR/actual.txt"
    exit 1
fi
rm -f "$DIR/actual.txt"

sqlite3 -batch -header -list -separator '|' "$DB" < "$DIR/check-15-rollback.sql" > "$DIR/actual.txt" 2>/dev/null || true
if diff -q "$DIR/expected-15-rollback.txt" "$DIR/actual.txt" > /dev/null; then
    echo "OK   consulta-15-transaccion-compra"
    rm -f "$DIR/actual.txt"
    exit 0
fi
echo "FAIL consulta-15-transaccion-compra (rollback no aplicado)"
diff "$DIR/expected-15-rollback.txt" "$DIR/actual.txt"
rm -f "$DIR/actual.txt"
exit 1