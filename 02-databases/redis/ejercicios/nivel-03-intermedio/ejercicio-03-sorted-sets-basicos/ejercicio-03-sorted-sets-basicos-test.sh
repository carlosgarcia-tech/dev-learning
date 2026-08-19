#!/usr/bin/env bash
# Verificación: ejercicio-03-sorted-sets-basicos
set -u
cd "$(dirname "$0")" || exit 1

CTR="redis-ej-$$"
SETUP="ejercicio-03-sorted-sets-basicos-setup.redis"
SOL="ejercicio-03-sorted-sets-basicos-solucion.redis"
EXPECTED="ejercicio-03-sorted-sets-basicos-expected.txt"

cleanup() {
    podman rm -f "$CTR" >/dev/null 2>&1
    rm -f tmp_actual.txt
}
trap cleanup EXIT

podman run -d --name "$CTR" docker.io/library/redis:7-alpine >/dev/null 2>&1 || {
    echo "FAIL: no se pudo levantar redis (podman)"
    exit 1
}

for i in $(seq 1 30); do
    if podman exec "$CTR" redis-cli ping >/dev/null 2>&1; then break; fi
    sleep 0.2
done

podman exec -i "$CTR" redis-cli < "$SETUP" >/dev/null 2>&1 || {
    echo "FAIL: no se pudo aplicar el setup"
    exit 1
}

podman exec -i "$CTR" redis-cli < "$SOL" > tmp_actual.txt 2>&1

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
