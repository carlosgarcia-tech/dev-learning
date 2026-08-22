#!/usr/bin/env bash
# Validación del ejercicio 04 - CSRF token.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

CSRF_FILE="csrf.json"

if [[ ! -f "$CSRF_FILE" ]]; then
  echo "FAIL: falta $CSRF_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$CSRF_FILE" <<'PY'
import json, sys, hmac

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

token_esperado = data.get("token_esperado", "")
if not token_esperado:
    errors.append("token_esperado no puede estar vacío")

escenarios = data.get("escenarios", [])
if len(escenarios) != 3:
    errors.append(f"Debe haber 3 escenarios, hay {len(escenarios)}")
else:
    # Escenario 1: token correcto
    e1 = escenarios[0]
    if e1.get("nombre") != "token_correcto":
        errors.append(f"Escenario 1: nombre debe ser 'token_correcto', es '{e1.get('nombre')}'")
    if e1.get("valido") is not True:
        errors.append("Escenario 1: valido debe ser true")
    if e1.get("status") != "success":
        errors.append(f"Escenario 1: status debe ser 'success', es '{e1.get('status')}'")
    # Verificar que el token coincide realmente
    if e1.get("token_recibido") != token_esperado:
        errors.append("Escenario 1: token_recibido debe coincidir con token_esperado")
    
    # Escenario 2: token ausente
    e2 = escenarios[1]
    if e2.get("nombre") != "token_ausente":
        errors.append(f"Escenario 2: nombre debe ser 'token_ausente', es '{e2.get('nombre')}'")
    if e2.get("valido") is not False:
        errors.append("Escenario 2: valido debe ser false")
    if e2.get("status") != "error":
        errors.append(f"Escenario 2: status debe ser 'error', es '{e2.get('status')}'")
    if e2.get("token_recibido") is not None:
        errors.append("Escenario 2: token_recibido debe ser null")
    
    # Escenario 3: token incorrecto
    e3 = escenarios[2]
    if e3.get("nombre") != "token_incorrecto":
        errors.append(f"Escenario 3: nombre debe ser 'token_incorrecto', es '{e3.get('nombre')}'")
    if e3.get("valido") is not False:
        errors.append("Escenario 3: valido debe ser false")
    if e3.get("status") != "error":
        errors.append(f"Escenario 3: status debe ser 'error', es '{e3.get('status')}'")
    # Verificar que el token NO coincide
    if e3.get("token_recibido") == token_esperado:
        errors.append("Escenario 3: token_recibido NO debe coincidir con token_esperado")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
