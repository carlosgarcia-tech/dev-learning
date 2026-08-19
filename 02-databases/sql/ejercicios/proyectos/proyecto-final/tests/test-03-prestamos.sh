#!/bin/bash
# Prueba el flujo de préstamo y devolución usando los triggers de SQLite:
#   - insertar un préstamo decrementa el stock,
#   - fijar fecha_devolucion marca el préstamo como devuelto, calcula la
#     multa (0.50 €/día de retraso) y restaura el stock,
#   - el límite de 3 préstamos activos por usuario se valida con RAISE(ABORT).
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB="$DIR/biblioteca.db"

cleanup() { rm -f "$DB"; }
trap cleanup EXIT

rm -f "$DB"
sqlite3 "$DB" < "$DIR/../schema.sql"
sqlite3 "$DB" < "$DIR/../functions/calcular-multa.sql"
sqlite3 "$DB" < "$DIR/../functions/actualizar-disponibilidad.sql"
sqlite3 "$DB" < "$DIR/../triggers/actualizar-stock.sql"
sqlite3 "$DB" < "$DIR/../triggers/auditoria-prestamos.sql"
sqlite3 "$DB" < "$DIR/../datos.sql"

# Préstamo del libro 2 para la usuaria 3 (sin préstamos activos)
STOCK_INICIAL=$(sqlite3 "$DB" "SELECT cantidad_disponible FROM libros WHERE id = 2;")
sqlite3 "$DB" "INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_limite, estado)
               VALUES (2, 3, '2024-07-10', '2024-07-24', 'activo');"
PRESTAMO_ID=$(sqlite3 "$DB" "SELECT MAX(id) FROM prestamos;")
STOCK_CREADO=$(sqlite3 "$DB" "SELECT cantidad_disponible FROM libros WHERE id = 2;")

if [ "$STOCK_CREADO" != "$((STOCK_INICIAL - 1))" ]; then
    echo "❌ El stock no se decrementó al crear el préstamo"
    exit 1
fi

# Devolución 6 días después de la fecha límite → multa esperada: 6 × 0.50 = 3.0
sqlite3 "$DB" "UPDATE prestamos SET fecha_devolucion = '2024-07-30' WHERE id = $PRESTAMO_ID;"

ESTADO=$(sqlite3 "$DB" "SELECT estado FROM prestamos WHERE id = $PRESTAMO_ID;")
MULTA=$(sqlite3 "$DB" "SELECT multa FROM prestamos WHERE id = $PRESTAMO_ID;")
STOCK_DEVUELTO=$(sqlite3 "$DB" "SELECT cantidad_disponible FROM libros WHERE id = 2;")

if [ "$ESTADO" != "devuelto" ]; then
    echo "❌ El préstamo no quedó marcado como devuelto"
    exit 1
fi
if ! awk -v m="$MULTA" 'BEGIN { exit !(m > 0) }'; then
    echo "❌ La multa no se calculó correctamente"
    exit 1
fi
if [ "$STOCK_DEVUELTO" != "$STOCK_INICIAL" ]; then
    echo "❌ El stock no se restableció al devolver"
    exit 1
fi

# Límite de 3 préstamos activos: la usuaria 1 ya tiene 1 activo; dos más
# superarían el límite y el trigger debe abortar la operación.
sqlite3 "$DB" "INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_limite, estado)
               VALUES (2, 1, '2024-07-10', '2024-07-24', 'activo');"
sqlite3 "$DB" "INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_limite, estado)
               VALUES (3, 1, '2024-07-10', '2024-07-24', 'activo');"
if ERROR=$(sqlite3 "$DB" "INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_limite, estado)
                          VALUES (4, 1, '2024-07-10', '2024-07-24', 'activo');" 2>&1); then
    echo "❌ No se bloqueó el 4º préstamo activo para la usuaria 1"
    exit 1
fi
case "$ERROR" in
    *"3 préstamos activos"*) ;;
    *)
        echo "❌ Mensaje de bloqueo inesperado: $ERROR"
        exit 1
        ;;
esac

echo "✅ Flujo de préstamo y devolución correcto (multa: $MULTA)"