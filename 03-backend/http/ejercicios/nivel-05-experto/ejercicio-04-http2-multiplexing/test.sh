#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 5) - HTTP/2 multiplexing.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
REQ="peticiones.http"

for f in "$RESP" "$REQ"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }

python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []
if str(data.get("conexiones_tcp", "")).strip() != "1":
    errors.append("conexiones_tcp debe ser '1'")
if "frame" not in str(data.get("unidades_datos", "")).lower():
    errors.append("unidades_datos debe mencionar 'frames'")
if "hpack" not in str(data.get("compresion_headers", "")).lower():
    errors.append("compresion_headers debe mencionar 'HPACK'")
if "tls" not in str(data.get("transporte_practica", "")).lower() and "https" not in str(data.get("transporte_practica", "")).lower():
    errors.append("transporte_practica debe mencionar TLS o HTTPS")
if data.get("resuelve_hol_blocking") is not False and str(data.get("resuelve_hol_blocking")).lower() != "false":
    errors.append("resuelve_hol_blocking debe ser false (HTTP/3 sí lo resuelve, HTTP/2 no)")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)
print("OK respuestas válidas")
PY

# peticiones.http debe mencionar streams/frames
grep -qi 'stream\|frame' "$REQ" || { echo "FAIL: peticiones.http debe mencionar streams o frames"; fail; }

echo "OK Tests pasaron"
