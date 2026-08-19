#!/usr/bin/env bash
# Verificación: ejercicio-01-set-y-get
set -u
cd "$(dirname "$0")" || exit 1

PORT=$((20000 + RANDOM % 10000))
CTR="redis-ej-01-$$"
SETUP="ejercicio-01-set-y-get-setup.redis"
SOL="ejercicio-01-set-y-get-solucion.redis"
EXPECTED="ejercicio-01-set-y-get-expected.txt"

cleanup() {
    podman rm -f "$CTR" >/dev/null 2>&1
    rm -f tmp_actual.txt
}
trap cleanup EXIT

podman run -d --name "$CTR" -p "$PORT:6379" docker.io/library/redis:7-alpine >/dev/null 2>&1 || {
    echo "FAIL: no se pudo levantar redis (podman)"
    exit 1
}

for i in $(seq 1 30); do
    if podman exec "$CTR" redis-cli ping >/dev/null 2>&1; then break; fi
    sleep 0.2
done

podman exec -i "$CTR" redis-cli < "$SETUP" >/dev/null || {
    echo "FAIL: no se pudo aplicar el setup"
    exit 1
}

podman exec -i "$CTR" redis-cli < "$SOL" > tmp_actual.txt

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