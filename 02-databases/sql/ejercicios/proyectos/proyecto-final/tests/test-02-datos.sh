#!/bin/bash
# Verifica que existan datos de ejemplo cargados.
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

COUNT_LIBROS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM libros;")
COUNT_USUARIOS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM usuarios;")

if [ "$COUNT_LIBROS" -lt 1 ] || [ "$COUNT_USUARIOS" -lt 1 ]; then
    echo "❌ Faltan datos de ejemplo"
    rm -f "$DB"
    exit 1
fi
echo "✅ Datos de ejemplo presentes ($COUNT_LIBROS libros, $COUNT_USUARIOS usuarios)"
rm -f "$DB"