#!/usr/bin/env bash
# Validación del ejercicio 03 - Códigos 200 y 404.
# Comprueba peticiones.http y expected.json, y consulta el servidor de prueba.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REQ="peticiones.http"
EXP="expected.json"
SRV="server.sh"

for f in "$REQ" "$EXP" "$SRV"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

# peticiones.http tiene las dos peticiones
grep -q '^GET /ok HTTP/1\.1$' "$REQ" || { echo "FAIL: falta 'GET /ok HTTP/1.1'"; fail; }
grep -q '^GET /inexistente HTTP/1\.1$' "$REQ" || { echo "FAIL: falta 'GET /inexistente HTTP/1.1'"; fail; }
grep -qi '^Host: localhost:8081$' "$REQ" || { echo "FAIL: falta 'Host: localhost:8081'"; fail; }

# expected.json válido
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Validar contenido del expected
python3 - "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
rutas = data.get("rutas", {})
if rutas.get("ok") != 200:
    print("FAIL: rutas.ok debe ser 200"); sys.exit(1)
if rutas.get("no_encontrada") != 404:
    print("FAIL: rutas.no_encontrada debe ser 404"); sys.exit(1)
print("OK (expected)")
PY

# Levantar servidor y comprobar los códigos reales
PORT=8081
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/ok" >/dev/null 2>&1 && break
  sleep 0.1
done

CODE_OK=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/ok") || { echo "FAIL: curl falló"; fail; }
CODE_404=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/inexistente") || { echo "FAIL: curl falló"; fail; }

[[ "$CODE_OK" == "200" ]] || { echo "FAIL: /ok devolvió $CODE_OK, esperado 200"; fail; }
[[ "$CODE_404" == "404" ]] || { echo "FAIL: /inexistente devolvió $CODE_404, esperado 404"; fail; }

echo "OK Tests pasaron"
