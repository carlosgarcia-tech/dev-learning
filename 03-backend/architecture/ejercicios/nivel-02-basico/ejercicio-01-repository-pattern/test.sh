#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 02) - Repository pattern.
# Comprueba que el dominio dependa de la interfaz y que InMemory funcione.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.py"
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

# 4. solucion.py compila
if ! python3 -c "import py_compile; py_compile.compile('$SOL', doraise=True)" 2>/dev/null; then
  echo "FAIL: $SOL no compila con python3"
  fail
fi

# 5. Define las clases requeridas
for cls in "UserRepository" "InMemoryUserRepository" "MySQLUserRepository" "UserService"; do
  if ! grep -q "class $cls" "$SOL"; then
    echo "FAIL: $SOL debe definir la clase $cls"
    fail
  fi
done

# 6. UserRepository es abstracta con los 3 métodos
if ! grep -qE "abstractmethod" "$SOL"; then
  echo "FAIL: UserRepository debe ser abstracta (usar @abstractmethod)"
  fail
fi
for m in "def save" "def find_by_id" "def find_by_email"; do
  if ! grep -q "$m" "$SOL"; then
    echo "FAIL: UserRepository debe tener método $m"
    fail
  fi
done

# 7. UserService recibe el repo por constructor
if ! grep -qE "def __init__\s*\(self,\s*repo" "$SOL"; then
  echo "FAIL: UserService.__init__ debe recibir repo por parámetro"
  fail
fi

# 8. UserService NO usa SQL directamente (debe delegar al repo)
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"class UserService.*?\n}(?:\s*\n)", src, re.S)
if not m:
    print("FAIL: no se pudo aislar la clase UserService"); sys.exit(1)
bloque = m.group(0)
if re.search(r"INSERT\s+INTO|SELECT\s+\*|UPDATE\s+\w+\s+SET|DELETE\s+FROM", bloque, re.I):
    print("FAIL: UserService no debe contener SQL directo (debe usar el repo)")
    sys.exit(1)
PY

# 9. Verificación funcional con InMemory
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

repo = m.InMemoryUserRepository()
svc = m.UserService(repo)
u = svc.register("a@b.com")
if u["email"] != "a@b.com":
    print("FAIL: register debe devolver el usuario"); sys.exit(1)
# duplicado
try:
    svc.register("a@b.com")
    print("FAIL: register duplicado debe lanzar ValueError"); sys.exit(1)
except ValueError:
    pass
# find_by_id
if repo.find_by_id(u["id"])["email"] != "a@b.com":
    print("FAIL: find_by_id debe devolver el usuario"); sys.exit(1)
PY

echo "OK Tests pasaron"
