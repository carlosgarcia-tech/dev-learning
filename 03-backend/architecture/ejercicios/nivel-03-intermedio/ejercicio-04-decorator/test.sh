#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 03) - Decorator.
# Comprueba decoradores combinables que suman coste y descripción.
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

for cls in "Cafe" "CafeSimple" "CafeDecorator" "Leche" "Azucar" "ExtraShot"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
grep -qE "coste\s*\(" "$SOL" || { echo "FAIL: debe haber coste()"; fail; }
grep -qE "desc\s*\(" "$SOL" || { echo "FAIL: debe haber desc()"; fail; }

# Los decoradores extienden CafeDecorator
grep -qE "class Leche\s+extends\s+CafeDecorator" "$SOL" || { echo "FAIL: Leche debe extender CafeDecorator"; fail; }
grep -qE "class Azucar\s+extends\s+CafeDecorator" "$SOL" || { echo "FAIL: Azucar debe extender CafeDecorator"; fail; }

# Verificación funcional
node -e '
const { CafeSimple, Leche, Azucar, ExtraShot } = require("./'"$SOL"'");
const simple = new CafeSimple();
if (simple.coste() !== 2) { console.error("FAIL: CafeSimple → 2"); process.exit(1); }
const c = new Azucar(new Leche(new CafeSimple()));
if (c.coste() !== 2.7) { console.error("FAIL: Leche+Azucar → 2.7, es", c.coste()); process.exit(1); }
if (!c.desc().includes("Leche") || !c.desc().includes("Azúcar")) { console.error("FAIL: desc debe incluir Leche y Azúcar"); process.exit(1); }
const triple = new ExtraShot(new Azucar(new Leche(new CafeSimple())));
if (triple.coste() !== 3.5) { console.error("FAIL: ExtraShot+Leche+Azucar → 3.5, es", triple.coste()); process.exit(1); }
' || fail

echo "OK Tests pasaron"
