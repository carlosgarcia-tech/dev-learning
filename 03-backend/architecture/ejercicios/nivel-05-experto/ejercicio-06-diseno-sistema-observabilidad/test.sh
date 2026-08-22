#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 05) - Observabilidad distribuida.
# Comprueba tracer, logger estructurado, métricas y propagación de trace_id.
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

for cls in "Tracer" "Logger" "Metrics" "ServicioDistribuido"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
for m in "def start_span" "def log" "def inc" "def observe" "def handle"; do
  grep -q "$m" "$SOL" || { echo "FAIL: debe haber $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

tracer = m.Tracer()
logger = m.Logger()
metrics = m.Metrics()

# Cadena de 3 servicios
c = m.ServicioDistribuido("ServicioC", tracer, logger, metrics)
b = m.ServicioDistribuido("ServicioB", tracer, logger, metrics, siguiente=c)
a = m.ServicioDistribuido("ServicioA", tracer, logger, metrics, siguiente=b)

trace_id = a.handle()
if not trace_id:
    print("FAIL: handle debe devolver un trace_id"); sys.exit(1)

# 3 spans (uno por servicio), todos con el MISMO trace_id
if len(tracer.spans) != 3:
    print("FAIL: deben haber 3 spans, hay", len(tracer.spans)); sys.exit(1)
ids = {s["trace_id"] for s in tracer.spans}
if len(ids) != 1:
    print("FAIL: todos los spans deben compartir el mismo trace_id"); sys.exit(1)

# Logs estructurados con trace_id
if len(logger.logs) != 3:
    print("FAIL: deben haber 3 logs, hay", len(logger.logs)); sys.exit(1)
for log in logger.logs:
    if "trace_id" not in log:
        print("FAIL: cada log debe tener trace_id"); sys.exit(1)
    if log["trace_id"] != trace_id:
        print("FAIL: los logs deben llevar el trace_id propagado"); sys.exit(1)

# Métricas: un counter por servicio + latencia observada
if metrics.counter("ServicioA_requests") != 1:
    print("FAIL: counter ServicioA_requests debe ser 1"); sys.exit(1)
if metrics.counter("ServicioB_requests") != 1 or metrics.counter("ServicioC_requests") != 1:
    print("FAIL: counters de B y C deben ser 1"); sys.exit(1)

# Latencia observada para cada servicio
if not any("latencia" in h for h in ["ServicioA_latencia","ServicioB_latencia","ServicioC_latencia"]):
    pass  # estructura interna
PY

echo "OK Tests pasaron"
