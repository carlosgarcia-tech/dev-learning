#!/usr/bin/env bash
# Validación del ejercicio 04 - Singleton.
# Comprueba que Config garantice una sola instancia y comparta estado.
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

# 5. Define la clase Config y __new__
if ! grep -q "class Config" "$SOL"; then
  echo "FAIL: $SOL debe definir la clase Config"
  fail
fi
if ! grep -qE "def __new__" "$SOL"; then
  echo "FAIL: Config debe override __new__ para garantizar una sola instancia"
  fail
fi

# 6. Métodos set y get
if ! grep -qE "def set" "$SOL"; then
  echo "FAIL: Config debe tener método set"
  fail
fi
if ! grep -qE "def get" "$SOL"; then
  echo "FAIL: Config debe tener método get"
  fail
fi

# 7. Verificación funcional: identidad y estado compartido
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

c1 = m.Config()
c2 = m.Config()
if c1 is not c2:
    print("FAIL: Config() is Config() debe ser True (misma instancia)")
    sys.exit(1)
c1.set("db", "postgres")
if c2.get("db") != "postgres":
    print("FAIL: el valor set en c1 debe ser visible en c2")
    sys.exit(1)
if c2.get("no_existe", "def") != "def":
    print("FAIL: get debe devolver default para claves inexistentes")
    sys.exit(1)
PY

echo "OK Tests pasaron"
