#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 02) - Dependency Injection container.
# Comprueba registro, resolución e inyección recursiva de dependencias.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.py"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
python3 -c "import py_compile; py_compile.compile('$SOL', doraise=True)" 2>/dev/null || { echo "FAIL: $SOL no compila"; fail; }

grep -q "class Container" "$SOL" || { echo "FAIL: debe definir Container"; fail; }
grep -qE "def register" "$SOL" || { echo "FAIL: Container debe tener register"; fail; }
grep -qE "def resolve" "$SOL" || { echo "FAIL: Container debe tener resolve"; fail; }

# Verificación funcional: registro + resolución con inyección
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

c = m.Container()
c.register(m.UserRepository, m.UserRepository)
c.register(m.UserService, m.UserService)
svc = c.resolve(m.UserService)
# El repo debe estar inyectado
if not hasattr(svc, "repo") or svc.repo is None:
    print("FAIL: UserService debe tener el repo inyectado"); sys.exit(1)
if svc.get_user(1) != {"id": 1, "name": "Ana"}:
    print("FAIL: get_user(1) debe devolver el usuario"); sys.exit(1)

# resolve de algo no registrado debe fallar
try:
    c.resolve("NoExiste")
    print("FAIL: resolve de no registrado debe lanzar error"); sys.exit(1)
except (KeyError, Exception):
    pass
PY

echo "OK Tests pasaron"
