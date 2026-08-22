#!/usr/bin/env bash
# Validación del ejercicio 06 - Comparación timing-safe.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

COMP_FILE="comparacion.json"
TOK_FILE="tokens.json"

for f in "$COMP_FILE" "$TOK_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$COMP_FILE" "$TOK_FILE" <<'PY'
import json, sys, hmac

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    tok = json.load(f)

errors = []

# coinciden: los tokens son iguales → true
if data.get("coinciden") is not True:
    errors.append(f"coinciden debe ser true (los tokens son iguales), es {data.get('coinciden')}")

# Verificación real: los tokens del archivo coinciden
if not hmac.compare_digest(tok["token_esperado"], tok["token_recibido"]):
    errors.append("los tokens en tokens.json no coinciden")

# metodo_igual_doble: vulnerable
if data.get("metodo_igual_doble") != "vulnerable":
    errors.append(f"metodo_igual_doble debe ser 'vulnerable', es '{data.get('metodo_igual_doble')}'")

# metodo_compare_digest: seguro
if data.get("metodo_compare_digest") != "seguro":
    errors.append(f"metodo_compare_digest debe ser 'seguro', es '{data.get('metodo_compare_digest')}'")

# explicacion: mínimo 20 caracteres
exp = data.get("explicacion", "")
if len(exp) < 20:
    errors.append(f"explicacion debe tener mínimo 20 caracteres, tiene {len(exp)}")

# explicacion debe mencionar "tiempo" o "timing"
if "tiempo" not in exp.lower() and "timing" not in exp.lower():
    errors.append("explicacion debe mencionar 'tiempo' o 'timing'")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
