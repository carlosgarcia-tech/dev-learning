#!/bin/bash
# Verifica que todas las tablas del esquema existan.
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB="$DIR/biblioteca.db"

rm -f "$DB"
sqlite3 "$DB" < "$DIR/../schema.sql"
sqlite3 "$DB" < "$DIR/../functions/calcular-multa.sql"
sqlite3 "$DB" < "$DIR/../functions/actualizar-disponibilidad.sql"
sqlite3 "$DB" < "$DIR/../triggers/actualizar-stock.sql"
sqlite3 "$DB" < "$DIR/../triggers/auditoria-prestamos.sql"
sqlite3 "$DB" < "$DIR/../datos.sql"

TABLAS="autores usuarios libros prestamos auditoria_prestamos"
for t in $TABLAS; do
    RESULT=$(sqlite3 "$DB" "SELECT name FROM sqlite_master WHERE type='table' AND name='$t';")
    if [ -z "$RESULT" ]; then
        echo "❌ Falta la tabla: $t"
        rm -f "$DB"
        exit 1
    fi
done
echo "✅ Todas las tablas existen"
rm -f "$DB"