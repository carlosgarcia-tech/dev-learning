#!/usr/bin/env bash
# Verificación: ejercicio-05-transacciones-y-concurrencia
#
# Simula DOS sesiones concurrentes sobre la misma base de datos:
#   - Sesión A: ejecuta la solución (BEGIN + UPDATE sin commitear) y mantiene
#     la transacción abierta alimentando sqlite3 a través de un FIFO.
#   - Sesión B: lee (no debe ver el cambio), intenta escribir (debe quedar
#     bloqueada por el bloqueo de escritura de A) y, tras el ROLLBACK de A,
#     consigue escribir y lee el resultado.
set -u
cd "$(dirname "$0")" || exit 1

DB="tmp.db"
SCHEMA="ejercicio-05-transacciones-y-concurrencia-schema.sql"
SOL="ejercicio-05-transacciones-y-concurrencia-solucion.sql"
EXPECTED="ejercicio-05-transacciones-y-concurrencia-expected.txt"
FIFO="tmp_sesion_a.fifo"
OUT_A="tmp_sesion_a.out"
ERR_A="tmp_sesion_a.err"
ACTUAL="tmp_actual.txt"

A_PID=""
cleanup() {
    exec 3>&- 2>/dev/null || true
    if [ -n "$A_PID" ]; then
        kill "$A_PID" 2>/dev/null
        wait "$A_PID" 2>/dev/null
    fi
    rm -f "$DB" "$FIFO" "$OUT_A" "$ERR_A" "$ACTUAL"
}
trap cleanup EXIT

rm -f "$DB" "$FIFO"
if ! sqlite3 -batch "$DB" < "$SCHEMA" 2>/dev/null; then
    echo "FAIL: no se pudo cargar el schema inicial"
    exit 1
fi

# --- Sesión A: transacción abierta leyendo SQL desde un FIFO ---
mkfifo "$FIFO"
sqlite3 -batch "$DB" < "$FIFO" > "$OUT_A" 2> "$ERR_A" &
A_PID=$!

# Abrir el FIFO para escritura (mantenerlo abierto evita el EOF)
exec 3> "$FIFO"

# Enviar la solución de la sesión A (BEGIN + UPDATE sin commitear).
# Se añade un salto de línea final para que sqlite3 procese siempre la
# última sentencia aunque el archivo no termine en newline.
{ cat "$SOL"; printf '\n'; } >&3

# Dar tiempo a que la sesión A tome el bloqueo de escritura
sleep 0.5

# --- Sesión B: leer sin commitear (debe seguir en 100) ---
B_READ1="$(sqlite3 -batch "$DB" "SELECT stock FROM inventario WHERE id = 1;")"

# --- Sesión B: escribir mientras A mantiene el bloqueo (debe quedar bloqueada) ---
if sqlite3 -batch "$DB" "UPDATE inventario SET stock = 1 WHERE id = 2;" > /dev/null 2>&1; then
    B_WRITE="NOT_LOCKED"
else
    B_WRITE="LOCKED"
fi

# --- Sesión A: deshacer la transacción ---
echo "ROLLBACK;" >&3
exec 3>&-

# Esperar a que la sesión A termine
wait "$A_PID" 2>/dev/null
A_PID=""

# --- Sesión B: ya puede escribir y leer el resultado ---
sqlite3 -batch "$DB" "UPDATE inventario SET stock = 1 WHERE id = 2;" > /dev/null 2>&1
B_READ2="$(sqlite3 -batch "$DB" "SELECT stock FROM inventario WHERE id = 2;")"

printf '%s\n%s\n%s\n' "$B_READ1" "$B_WRITE" "$B_READ2" > "$ACTUAL"

if diff -q "$EXPECTED" "$ACTUAL" > /dev/null 2>&1; then
    echo "OK"
    exit 0
else
    echo "FAIL"
    echo "--- diff (esperado vs obtenido) ---"
    diff -u "$EXPECTED" "$ACTUAL"
    echo "--- obtenido ---"
    cat "$ACTUAL"
    exit 1
fi