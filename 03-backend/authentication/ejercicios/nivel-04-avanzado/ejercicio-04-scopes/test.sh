#!/usr/bin/env bash
# Validación del ejercicio 04 - Scopes y consentimiento.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SCO_FILE="scopes.json"

if [[ ! -f "$SCO_FILE" ]]; then
  echo "FAIL: falta $SCO_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$SCO_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

solicitados = data.get("scopes_solicitados", [])
if len(solicitados) != 5:
    errors.append(f"scopes_solicitados debe tener 5 elementos, tiene {len(solicitados)}")

consent = data.get("consentimiento", [])
if len(consent) != 5:
    errors.append(f"consentimiento debe tener 5 elementos, tiene {len(consent)}")
else:
    expected = {
        "openid": True, "profile": True, "email": True,
        "photos:read": True, "photos:write": False
    }
    for c in consent:
        scope = c.get("scope", "")
        concedido = c.get("concedido")
        if scope in expected:
            if concedido is not expected[scope]:
                errors.append(f"consentimiento '{scope}': concedido debe ser {expected[scope]}, es {concedido}")
        else:
            errors.append(f"scope desconocido en consentimiento: '{scope}'")

# scopes_finales: 4 scopes concedidos (sin photos:write)
finales = data.get("scopes_finales", [])
expected_finales = ["openid", "profile", "email", "photos:read"]
if len(finales) != 4:
    errors.append(f"scopes_finales debe tener 4 elementos, tiene {len(finales)}")
else:
    for s in expected_finales:
        if s not in finales:
            errors.append(f"scopes_finales debe contener '{s}'")
    if "photos:write" in finales:
        errors.append("scopes_finales NO debe contener 'photos:write' (fue denegado)")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
