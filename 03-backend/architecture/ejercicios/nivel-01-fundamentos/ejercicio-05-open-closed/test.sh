#!/usr/bin/env bash
# Validación del ejercicio 05 - Open/Closed Principle.
# Comprueba que precioFinal no use if por tipo y que los descuentos sean polimórficos.
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

# 4. node disponible
if ! command -v node >/dev/null 2>&1; then
  echo "FAIL: se requiere node"
  fail
fi

# 5. solucion.js compila
if ! node --check "$SOL" 2>/dev/null; then
  echo "FAIL: $SOL no compila con node --check"
  fail
fi

# 6. Define las clases y la función
for sym in "class Descuento" "class SinDescuento" "class DescuentoVIP" "class DescuentoBlackFriday"; do
  if ! grep -q "$sym" "$SOL"; then
    echo "FAIL: $SOL debe definir $sym"
    fail
  fi
done
if ! grep -qE "function precioFinal|const precioFinal|precioFinal\s*=" "$SOL"; then
  echo "FAIL: $SOL debe definir precioFinal"
  fail
fi

# 7. precioFinal NO contiene 'if' (OCP: despacha por polimorfismo)
#    Extraemos el cuerpo de la función precioFinal
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"function precioFinal\s*\([^)]*\)\s*{", src)
if m:
    start = m.end()
    depth = 1; i = start
    while i < len(src) and depth > 0:
        if src[i] == "{": depth += 1
        elif src[i] == "}": depth -= 1
        i += 1
    cuerpo = src[start:i-1]
    if re.search(r"\bif\b", cuerpo):
        print("FAIL: precioFinal contiene 'if' → viola OCP")
        sys.exit(1)
PY

# 8. Verificación funcional
node -e '
const { SinDescuento, DescuentoVIP, DescuentoBlackFriday, precioFinal, Carrito } = require("./'"$SOL"'");
if (precioFinal(new SinDescuento(), 100) !== 100) { console.error("FAIL: SinDescuento 100→100"); process.exit(1); }
if (precioFinal(new DescuentoVIP(), 100) !== 80) { console.error("FAIL: VIP 100→80"); process.exit(1); }
if (precioFinal(new DescuentoBlackFriday(), 100) !== 50) { console.error("FAIL: BF 100→50"); process.exit(1); }
const c = new Carrito(new DescuentoVIP()); c.add(50).add(50);
if (c.total() !== 80) { console.error("FAIL: carrito VIP 100→80"); process.exit(1); }
' || fail

echo "OK Tests pasaron"
