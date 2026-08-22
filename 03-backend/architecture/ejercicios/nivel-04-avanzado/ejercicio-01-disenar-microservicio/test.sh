#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 04) - Diseñar microservicio.
# Comprueba que solucion.json cumpla el schema del diseño.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.json"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

# Ambos JSON válidos
python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
python3 -m json.tool "$SOL" >/dev/null 2>&1 || { echo "FAIL: $SOL no es JSON válido"; fail; }

# Validación del schema
python3 - "$SOL" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)

# Campos obligatorios
for k in ("nombre", "bounded_context", "responsabilidad", "base_de_datos", "endpoints", "eventos_publicados", "eventos_consumidos"):
    if k not in d:
        print(f"FAIL: solucion.json debe tener '{k}'"); sys.exit(1)

# BD propia (no compartida)
bd = d["base_de_datos"]
if bd.get("compartida") is True:
    print("FAIL: la base de datos debe ser propia (compartida=false)"); sys.exit(1)
if not bd.get("nombre"):
    print("FAIL: la base de datos debe tener nombre"); sys.exit(1)

# Al menos 3 endpoints
eps = d["endpoints"]
if len(eps) < 3:
    print(f"FAIL: debe tener al menos 3 endpoints, hay {len(eps)}"); sys.exit(1)
for e in eps:
    if not all(k in e for k in ("metodo", "ruta", "descripcion")):
        print("FAIL: cada endpoint debe tener metodo, ruta, descripcion"); sys.exit(1)

# Al menos un evento publicado (PedidoCreado)
pubs = d["eventos_publicados"]
if len(pubs) < 1:
    print("FAIL: debe publicar al menos un evento"); sys.exit(1)
if not any(ev["nombre"] == "PedidoCreado" for ev in pubs):
    print("FAIL: debe publicar el evento PedidoCreado"); sys.exit(1)

# Al menos un evento consumido
cons = d["eventos_consumidos"]
if len(cons) < 1:
    print("FAIL: debe consumir al menos un evento"); sys.exit(1)
PY

echo "OK Tests pasaron"
