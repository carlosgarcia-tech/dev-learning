#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 04) - CQRS.
# Comprueba separación write/read y sincronización por eventos.
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

for cls in "UsuarioCreado" "CrearUsuarioHandler" "UsuarioProjector" "ObtenerUsuarioHandler" "Bus"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done

for m in "def handle" "def on_usuario_creado" "def publish" "def subscribe"; do
  grep -q "$m" "$SOL" || { echo "FAIL: debe haber $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

write_model = []
read_model = {}
bus = m.Bus()
projector = m.UsuarioProjector(read_model)
bus.subscribe(m.UsuarioCreado, projector.on_usuario_creado)

# Command: crear usuario
cmd_handler = m.CrearUsuarioHandler(write_model, bus)
created = cmd_handler.handle({"id": "u-1", "email": "ana@test.com"})
if created["id"] != "u-1":
    print("FAIL: command debe crear el usuario"); sys.exit(1)

# El projector debe haber actualizado el read model
if "u-1" not in read_model:
    print("FAIL: el read model debe tener u-1 tras el evento"); sys.exit(1)

# Query: leer del read model (vista denormalizada con email_domain)
query_handler = m.ObtenerUsuarioHandler(read_model)
v = query_handler.handle({"id": "u-1"})
if not v or v["email"] != "ana@test.com":
    print("FAIL: query debe devolver el usuario"); sys.exit(1)
if v["email_domain"] != "test.com":
    print("FAIL: read model debe tener email_domain denormalizado"); sys.exit(1)

# El read model es DISTINTO del write model (denormalizado)
if v == write_model[0]:
    print("FAIL: read model debe ser una vista distinta del write model"); sys.exit(1)
PY

echo "OK Tests pasaron"
