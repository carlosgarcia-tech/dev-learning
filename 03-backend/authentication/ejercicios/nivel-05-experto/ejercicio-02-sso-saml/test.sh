#!/usr/bin/env bash
# Validación del ejercicio 02 - SSO SAML.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SAML_FILE="saml.json"

if [[ ! -f "$SAML_FILE" ]]; then
  echo "FAIL: falta $SAML_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$SAML_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

idp = data.get("idp", {})
sp = data.get("sp", {})
asercion = data.get("asercion", {})

# idp y sp
if not idp.get("entity_id"):
    errors.append("idp.entity_id no puede estar vacío")
if not sp.get("entity_id"):
    errors.append("sp.entity_id no puede estar vacío")

# asercion
if not asercion.get("subject"):
    errors.append("asercion.subject no puede estar vacío")

# issuer debe coincidir con idp.entity_id
if asercion.get("issuer") != idp.get("entity_id"):
    errors.append(f"asercion.issuer debe coincidir con idp.entity_id: '{asercion.get('issuer')}' vs '{idp.get('entity_id')}'")

# audience debe coincidir con sp.entity_id
if asercion.get("audience") != sp.get("entity_id"):
    errors.append(f"asercion.audience debe coincidir con sp.entity_id: '{asercion.get('audience')}' vs '{sp.get('entity_id')}'")

# atributos
atributos = asercion.get("atributos", {})
if "role" not in atributos:
    errors.append("asercion.atributos debe contener 'role'")
if "email" not in atributos:
    errors.append("asercion.atributos debe contener 'email'")

# firmada
if asercion.get("firmada") is not True:
    errors.append("asercion.firmada debe ser true")

# flujo: 5 pasos
flujo = data.get("flujo", [])
if len(flujo) != 5:
    errors.append(f"flujo debe tener 5 pasos, tiene {len(flujo)}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
