#!/usr/bin/env bash
# Verificación: ejercicio-06-agregados-basicos
set -u
cd "$(dirname "$0")" || exit 1

CTR="mongo-ej-$$"
WORK="$(pwd)"
SETUP="ejercicio-06-agregados-basicos-setup.js"
SOL="ejercicio-06-agregados-basicos-solucion.js"
EXPECTED="ejercicio-06-agregados-basicos-expected.txt"

cleanup() {
    podman rm -f "$CTR" >/dev/null 2>&1
    rm -f tmp_actual.txt
}
trap cleanup EXIT

podman run -d --name "$CTR" -v "$WORK:/work:Z" docker.io/library/mongo:7 >/dev/null 2>&1 || {
    echo "FAIL: no se pudo levantar mongo (podman)"
    exit 1
}

for i in $(seq 1 30); do
    if podman exec "$CTR" mongosh --quiet --eval "db.runCommand({ping:1})" >/dev/null 2>&1; then break; fi
    sleep 0.2
done

podman exec "$CTR" mongosh --quiet --file /work/"$SETUP" ejercicios_db >/dev/null 2>&1 || {
    echo "FAIL: no se pudo aplicar el setup"
    exit 1
}

podman exec "$CTR" mongosh --quiet --file /work/"$SOL" ejercicios_db > tmp_actual.txt 2>&1

if diff -q "$EXPECTED" tmp_actual.txt > /dev/null 2>&1; then
    echo "OK"
    exit 0
else
    echo "FAIL"
    echo "--- diff (esperado vs obtenido) ---"
    diff -u "$EXPECTED" tmp_actual.txt
    echo "--- obtenido ---"
    cat tmp_actual.txt
    exit 1
fi