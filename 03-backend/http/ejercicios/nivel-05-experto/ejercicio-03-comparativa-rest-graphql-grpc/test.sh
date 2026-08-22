#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 5) - comparativa REST/GraphQL/gRPC.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
EXP="expected.json"
REQ="peticiones.http"

for f in "$RESP" "$EXP" "$REQ"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Comparar respuesta.json con expected.json
python3 - "$RESP" "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    r = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    e = json.load(f)

def compare(path, a, b):
    errors = []
    if isinstance(b, dict):
        for k, v in b.items():
            if k not in a:
                errors.append(f"falta '{path}.{k}'")
            elif isinstance(v, dict):
                errors.extend(compare(f"{path}.{k}", a[k], v))
            elif str(a[k]).lower() != str(v).lower():
                errors.append(f"'{path}.{k}': esperado '{v}', recibido '{a[k]}'")
    return errors

errors = compare("", r, e)
if errors:
    for er in errors:
        print("  -", er)
    sys.exit(1)
print("OK comparativa correcta")
PY

# Validar que peticiones.http tiene ejemplos de los tres
grep -q '^GET /products' "$REQ" || { echo "FAIL: falta ejemplo REST"; fail; }
grep -q '^POST /graphql' "$REQ" || { echo "FAIL: falta ejemplo GraphQL"; fail; }
grep -qi 'gRPC\|\.proto\|rpc' "$REQ" || { echo "FAIL: falta referencia a gRPC"; fail; }

echo "OK Tests pasaron"
