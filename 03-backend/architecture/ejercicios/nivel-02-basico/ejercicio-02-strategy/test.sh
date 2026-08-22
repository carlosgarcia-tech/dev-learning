#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 02) - Strategy.
# Comprueba estrategias intercambiables sin if por tipo.
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
node --check "$SOL" 2>/dev/null || { echo "FAIL: $SOL no compila con node --check"; fail; }

for sym in "class EstrategiaEnvio" "class EnvioEstandar" "class EnvioExpress" "class EnvioInternacional" "class CalculadoraEnvio"; do
  grep -q "$sym" "$SOL" || { echo "FAIL: $SOL debe definir $sym"; fail; }
done
grep -qE "calcular\s*\(" "$SOL" || { echo "FAIL: debe haber método calcular"; fail; }
grep -qE "setEstrategia\s*\(" "$SOL" || { echo "FAIL: CalculadoraEnvio debe tener setEstrategia"; fail; }

# Verificación funcional: cada estrategia da resultado distinto y setEstrategia cambia el comportamiento
node -e '
const { EnvioEstandar, EnvioExpress, EnvioInternacional, CalculadoraEnvio } = require("./'"$SOL"'");
const calc = new CalculadoraEnvio(new EnvioEstandar());
const e = calc.calcular(10, 100);    // 10 + 50 = 60
if (e !== 60) { console.error("FAIL: Estandar 10,100→60, es", e); process.exit(1); }
calc.setEstrategia(new EnvioExpress());
const x = calc.calcular(10, 100);    // 20 + 100 = 120
if (x !== 120) { console.error("FAIL: Express 10,100→120, es", x); process.exit(1); }
calc.setEstrategia(new EnvioInternacional());
const i = calc.calcular(10, 100);    // 30 + 200 = 230
if (i !== 230) { console.error("FAIL: Internacional 10,100→230, es", i); process.exit(1); }
// Las 3 deben dar resultados distintos
if (e === x || x === i || e === i) { console.error("FAIL: las estrategias deben dar resultados distintos"); process.exit(1); }
' || fail

echo "OK Tests pasaron"
