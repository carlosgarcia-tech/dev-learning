#!/usr/bin/env bash
# Validación del ejercicio 02 - Verificar contraseña contra hash bcrypt.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

VER_FILE="verificacion.json"

if [[ ! -f "$VER_FILE" ]]; then
  echo "FAIL: falta $VER_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$VER_FILE" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# password_correcta debe ser "password123"
if data.get("password_correcta") != "password123":
    errors.append(f"password_correcta debe ser 'password123', no '{data.get('password_correcta')}'")

# resultados: array de 4 elementos
resultados = data.get("resultados", [])
if len(resultados) != 4:
    errors.append(f"resultados debe tener 4 elementos, tiene {len(resultados)}")

# Exactamente una coincide
trues = [r for r in resultados if r.get("coincide") is True]
if len(trues) != 1:
    errors.append(f"exactamente 1 candidata debe coincidir, hay {len(trues)}")

# La que coincide debe ser password123
if trues and trues[0].get("password") != "password123":
    errors.append(f"la password correcta debe ser 'password123', no '{trues[0].get('password')}'")

# Cada resultado tiene password y coincide (bool)
for i, r in enumerate(resultados):
    if "password" not in r:
        errors.append(f"resultado {i} no tiene 'password'")
    if not isinstance(r.get("coincide"), bool):
        errors.append(f"resultado {i}: 'coincide' debe ser boolean")

# hash_almacenado debe tener formato bcrypt
ph = data.get("hash_almacenado", "")
if not re.match(r'^\$2[aby]\$\d{2}\$[A-Za-z0-9./]{53}$', ph):
    errors.append("hash_almacenado no tiene formato bcrypt válido")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
