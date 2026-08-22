#!/usr/bin/env bash
# Validación del ejercicio 02 - Separar responsabilidades (SRP).
# Comprueba que la clase Factura esté separada en 4 responsabilidades distintas.
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

# 4. estructura.json lista 4 responsabilidades
python3 - "$STRUCT" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    d = json.load(f)
resp = d.get("responsabilidades", [])
if len(resp) < 4:
    print(f"FAIL: estructura.json debe listar al menos 4 responsabilidades, hay {len(resp)}")
    sys.exit(1)
PY

# 5. node disponible
if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: se requiere node"
  fail
fi

# 6. solucion.js compila
if ! node --check "$SOL" 2>/dev/null; then
  echo "FAIL: $SOL no compila con node --check"
  fail
fi

# 7. Define las 4 clases + service
for cls in "Factura" "FacturaRepository" "FacturaSerializer" "FacturaMailer" "FacturaService"; do
  if ! grep -q "class $cls" "$SOL"; then
    echo "FAIL: $SOL debe definir la clase $cls"
    fail
  fi
done

# 8. La clase Factura tiene total() pero NO persistencia/serialización/email
#    Extraemos el bloque de la clase Factura
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"class Factura.*?\n}(?:\s*\n)", src, re.S)
if not m:
    print("FAIL: no se pudo aislar la clase Factura")
    sys.exit(1)
bloque = m.group(0)
if "INSERT" in bloque or "toXML" in bloque or "enviar" in bloque or "save" in bloque:
    print("FAIL: la clase Factura no debe contener persistencia/serialización/email")
    print("  bloque encontrado contiene lógica de otra responsabilidad")
    sys.exit(1)
if not re.search(r"\btotal\b\s*\(", bloque):
    print("FAIL: la clase Factura debe tener método total()")
    sys.exit(1)
PY

# 9. Métodos esperados en las clases especializadas
grep -qE 'save\s*\(' "$SOL" || { echo "FAIL: FacturaRepository debe tener save"; fail; }
grep -qE 'toXML\s*\(' "$SOL" || { echo "FAIL: FacturaSerializer debe tener toXML"; fail; }
grep -qE 'enviar\s*\(' "$SOL" || { echo "FAIL: FacturaMailer debe tener enviar"; fail; }

# 10. Verificación funcional
node -e '
const { Factura, FacturaRepository, FacturaSerializer, FacturaMailer, FacturaService } = require("./'"$SOL"'");
const f = new Factura([{precio:10,cantidad:2},{precio:5,cantidad:1}]);
if (f.total() !== 25) { console.error("FAIL: total debe ser 25, es", f.total()); process.exit(1); }
const svc = new FacturaService(f, new FacturaRepository(), new FacturaSerializer(), new FacturaMailer());
const r = svc.procesar();
if (!r.id || !r.xml || !r.mail) { console.error("FAIL: procesar debe devolver id, xml y mail"); process.exit(1); }
if (!r.xml.includes("25")) { console.error("FAIL: el XML debe contener el total"); process.exit(1); }
' || fail

echo "OK Tests pasaron"
