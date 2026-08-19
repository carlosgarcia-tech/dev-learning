#!/bin/bash
# Verifica que las consultas de reportes se ejecutan sin errores.
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

for f in "$DIR"/../consultas/*.sql; do
    sqlite3 "$DB" < "$f" > /dev/null
done
echo "✅ Todos los reportes se ejecutaron correctamente"
rm -f "$DB"