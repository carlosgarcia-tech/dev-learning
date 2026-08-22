#!/usr/bin/env bash
# Validación del ejercicio 01 - Petición GET con curl.
# Comprueba peticiones.http, levanta el servidor de prueba y consulta /saludo.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REQ="peticiones.http"
EXP="expected.json"
SRV="server.sh"

# 1. Archivos esperados existen
for f in "$REQ" "$EXP" "$SRV"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

# 2. python3 disponible
if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

# 3. curl disponible
if ! command -v curl >/dev/null 2>&1; then
  echo "FAIL: se requiere curl"
  fail
fi

# 4. peticiones.http tiene la request line y el Host
if ! grep -q '^GET /saludo HTTP/1\.1$' "$REQ"; then
  echo "FAIL: peticiones.http debe tener 'GET /saludo HTTP/1.1'"
  fail
fi
if ! grep -qi '^Host: localhost:8080$' "$REQ"; then
  echo "FAIL: peticiones.http debe tener 'Host: localhost:8080'"
  fail
fi

# 5. expected.json es JSON válido
if ! python3 -m json.tool "$EXP" >/dev/null 2>&1; then
  echo "FAIL: $EXP no es JSON válido"
  fail
fi

# 6. Levantar el servidor y consultar /saludo
PORT=8080
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

# Esperar a que el servidor arranque
for _ in $(seq 1 50); do
  if curl -s "http://127.0.0.1:$PORT/" >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

# Consultar la ruta /saludo
RESP="$(curl -s "http://127.0.0.1:$PORT/saludo")" || { echo "FAIL: curl falló"; fail; }

# Comparar el JSON recibido con el expected.json (normalizado)
python3 - "$RESP" "$EXP" <<'PY'
import json, sys
received, expected = sys.argv[1], sys.argv[2]
try:
    r = json.loads(received)
except Exception as e:
    print(f"FAIL: la respuesta no es JSON válido: {e}")
    sys.exit(1)
with open(expected, encoding="utf-8") as f:
    e = json.load(f)
if r != e:
    print("FAIL: la respuesta no coincide con expected.json")
    print("  recibido :", r)
    print("  esperado :", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
