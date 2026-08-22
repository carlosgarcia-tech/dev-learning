#!/usr/bin/env bash
# Validación del ejercicio 01 - Identificar capas.
# Comprueba estructura de archivos, sintaxis JS y separación de responsabilidades.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.js"
STRUCT="estructura.json"
DIAG="diagrama.txt"

# 1. Archivos esperados existen
for f in "$SOL" "$STRUCT" "$DIAG"; do
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

# 3. estructura.json es JSON válido
if ! python3 -m json.tool "$STRUCT" >/dev/null 2>&1; then
  echo "FAIL: $STRUCT no es JSON válido"
  fail
fi

# 4. estructura.json lista las 3 capas
python3 - "$STRUCT" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)
capas = d.get("capas", [])
for c in ("controller", "service", "repository"):
    if c not in capas:
        print(f"FAIL: estructura.json debe listar la capa '{c}'")
        sys.exit(1)
PY

# 5. node disponible (para validar JS)
if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: se requiere node"
  fail
fi

# 6. solucion.js es sintácticamente válido
if ! node --check "$SOL" 2>/dev/null; then
  echo "FAIL: $SOL no compila con node --check"
  fail
fi

# 7. Contiene las 3 clases requeridas
for cls in "UserRepository" "UserService" "UserController"; do
  if ! grep -q "class $cls" "$SOL"; then
    echo "FAIL: $SOL debe definir la clase $cls"
    fail
  fi
done

# 8. Repository tiene save
if ! grep -qE 'save\s*\(' "$SOL"; then
  echo "FAIL: UserRepository debe tener método save"
  fail
fi

# 9. Service tiene createUser y valida email
if ! grep -qE 'createUser\s*\(' "$SOL"; then
  echo "FAIL: UserService debe tener método createUser"
  fail
fi
if ! grep -qi "includes" "$SOL"; then
  echo "FAIL: UserService debe validar el email (busca '@')"
  fail
fi

# 10. Controller NO contiene SQL ni includes (no debe validar email)
if grep -qi "INSERT\|SELECT\|UPDATE\|DELETE" "$SOL"; then
  # el SQL podría estar en repository, permitimos repository.save sin texto SQL real
  if grep -qi "INSERT\|SELECT\|UPDATE\|DELETE" <(awk '/class UserController/,/^}/' "$SOL"); then
    echo "FAIL: UserController no debe contener SQL"
    fail
  fi
fi

# 11. Verificación funcional: el handler devuelve 201 para email válido
node -e '
const { UserController, UserService, UserRepository } = require("./'"$SOL"'");
const ctrl = new UserController(new UserService(new UserRepository()));
const ok = ctrl.postUser({ name: "Ana", email: "a@b.com" });
if (ok.status !== 201) { console.error("FAIL: status debe ser 201, es", ok.status); process.exit(1); }
if (!ok.body.email || ok.body.email !== "a@b.com") { console.error("FAIL: body.email incorrecto"); process.exit(1); }
const bad = ctrl.postUser({ name: "Mal", email: "no-email" });
if (bad.status !== 400) { console.error("FAIL: email inválido debe devolver 400, es", bad.status); process.exit(1); }
' || fail

echo "OK Tests pasaron"
