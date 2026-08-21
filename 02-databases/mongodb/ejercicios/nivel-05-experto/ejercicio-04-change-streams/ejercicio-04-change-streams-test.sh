#!/usr/bin/env bash
# Verificación: ejercicio-04-change-streams (REPLICA SET)
set -u
cd "$(dirname "$0")" || exit 1

CTR="mongo-rs-$$"
WORK="$(pwd)"
SETUP="ejercicio-04-change-streams-setup.js"
SOL="ejercicio-04-change-streams-solucion.js"
EXPECTED="ejercicio-04-change-streams-expected.txt"

cleanup() {
    podman rm -f "$CTR" >/dev/null 2>&1
    rm -f tmp_actual.txt
}
trap cleanup EXIT

podman run -d --name "$CTR" -v "$WORK:/work:Z" docker.io/library/mongo:7 mongod --replSet rs0 --bind_ip_all >/dev/null 2>&1 || {
    echo "FAIL: no se pudo levantar mongo (replica set)"
    exit 1
}

for i in $(seq 1 30); do
    if podman exec "$CTR" mongosh --quiet --eval "db.runCommand({ping:1})" >/dev/null 2>&1; then break; fi
    sleep 0.2
done

podman exec "$CTR" mongosh --quiet --eval "rs.initiate()" >/dev/null 2>&1

PRIMARY=0
for i in $(seq 1 60); do
    if podman exec "$CTR" mongosh --quiet --eval "db.hello().isWritablePrimary" 2>/dev/null | grep -q true; then
        PRIMARY=1
        break
    fi
    sleep 0.5
done

if [ "$PRIMARY" -ne 1 ]; then
    echo "FAIL: el nodo no alcanzó el estado PRIMARY"
    exit 1
fi

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