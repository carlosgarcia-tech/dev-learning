#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 03) - Hexagonal ports & adapters.
# Comprueba que el núcleo esté aislado por puertos.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.js"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v node >/dev/null 2>&1 || { echo "FAIL: se requiere node"; fail; }

python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
node --check "$SOL" 2>/dev/null || { echo "FAIL: $SOL no compila"; fail; }

for cls in "UserRepositoryPort" "CreateUserUseCase" "HttpUserController" "InMemoryUserRepository"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done

# InMemoryUserRepository hereda de UserRepositoryPort
grep -qE "class InMemoryUserRepository\s+extends\s+UserRepositoryPort" "$SOL" || { echo "FAIL: InMemoryUserRepository debe extender UserRepositoryPort"; fail; }

# El puerto tiene los métodos
grep -qE "save\s*\(" "$SOL" || { echo "FAIL: puerto debe tener save"; fail; }
grep -qE "findByEmail\s*\(" "$SOL" || { echo "FAIL: puerto debe tener findByEmail"; fail; }

# El use case NO referencia InMemoryUserRepository ni SQL (aislamiento)
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"class CreateUserUseCase.*?\n}(?:\s*\n)", src, re.S)
if not m:
    print("FAIL: no se pudo aislar CreateUserUseCase"); sys.exit(1)
bloque = m.group(0)
if "InMemoryUserRepository" in bloque:
    print("FAIL: el use case no debe conocer InMemoryUserRepository (acoplamiento)"); sys.exit(1)
if re.search(r"INSERT|SELECT", bloque, re.I):
    print("FAIL: el use case no debe contener SQL"); sys.exit(1)
PY

# Verificación funcional
node -e '
const { CreateUserUseCase, HttpUserController, InMemoryUserRepository } = require("./'"$SOL"'");
const repo = new InMemoryUserRepository();
const uc = new CreateUserUseCase(repo);
const ctrl = new HttpUserController(uc);
const ok = ctrl.post({ email: "a@b.com" });
if (ok.status !== 201 || !ok.body.id) { console.error("FAIL: crear → 201"); process.exit(1); }
const dup = ctrl.post({ email: "a@b.com" });
if (dup.status !== 400) { console.error("FAIL: duplicado → 400"); process.exit(1); }
' || fail

echo "OK Tests pasaron"
