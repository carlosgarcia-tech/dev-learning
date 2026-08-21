#!/usr/bin/env bash
# Nota: requiere un cluster K8s (kind/minikube) y helm para validación completa; sin cluster valida los YAML.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

# Localizar la carpeta del chart (miapp o solucion/miapp)
CHART_DIR=""
for cand in "miapp" "solucion/miapp"; do
  if [ -d "$cand" ] && [ -f "$cand/Chart.yaml" ] && [ -f "$cand/values.yaml" ]; then
    CHART_DIR="$cand"
    break
  fi
done
if [ -z "$CHART_DIR" ]; then
  fail "No se encontro el chart 'miapp' (con Chart.yaml y values.yaml) en ./miapp o ./solucion/miapp"
fi

# Validar Chart.yaml y values.yaml con yaml.safe_load
for f in "$CHART_DIR/Chart.yaml" "$CHART_DIR/values.yaml"; do
  python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null || fail "YAML invalido: $f"
done

# Validar los templates (templates/*.yaml) como YAML, eliminando las directivas {{ }}
tmpl_files=$(find "$CHART_DIR/templates" -maxdepth 1 -name '*.yaml' -type f 2>/dev/null | sort)
if [ -z "$tmpl_files" ]; then
  fail "No se encontraron templates en $CHART_DIR/templates/*.yaml"
fi

# Pre-procesar cada template reemplazando {{ ... }} por un valor de prueba y validar YAML
for f in $tmpl_files; do
  python3 - "$f" <<'PYEOF' || exit 1
import sys, re, yaml
path = sys.argv[1]
with open(path) as fh:
    content = fh.read()
# Reemplazar cada bloque {{ ... }} por un placeholder de texto valido
rendered = re.sub(r"\{\{[^}]*\}\}", "placeholder", content)
try:
    yaml.safe_load(rendered)
except yaml.YAMLError as e:
    print(f"YAML invalido en template {path}: {e}")
    sys.exit(1)
PYEOF
done

# Validaciones de estructura del chart
python3 - "$CHART_DIR" <<'PYEOF' || exit 1
import sys, yaml, os
chart_dir = sys.argv[1]

# Chart.yaml
with open(os.path.join(chart_dir, 'Chart.yaml')) as fh:
    chart = yaml.safe_load(fh)
if chart.get('apiVersion') != 'v2':
    print("Chart.yaml.apiVersion debe ser 'v2'")
    sys.exit(1)
for field in ('name', 'version', 'appVersion'):
    if field not in chart:
        print(f"Chart.yaml debe definir '{field}'")
        sys.exit(1)

# values.yaml
with open(os.path.join(chart_dir, 'values.yaml')) as fh:
    values = yaml.safe_load(fh)
if 'replicaCount' not in values:
    print("values.yaml debe definir 'replicaCount'")
    sys.exit(1)
image = values.get('image', {})
if 'repository' not in image or 'tag' not in image:
    print("values.yaml debe definir 'image.repository' y 'image.tag'")
    sys.exit(1)
service = values.get('service', {})
if 'port' not in service:
    print("values.yaml debe definir 'service.port'")
    sys.exit(1)

# templates
tmpl_dir = os.path.join(chart_dir, 'templates')
for name in ('deployment.yaml', 'service.yaml'):
    path = os.path.join(tmpl_dir, name)
    if not os.path.isfile(path):
        print(f"Falta el template {name} en templates/")
        sys.exit(1)
    with open(path) as fh:
        content = fh.read()
    if '{{' not in content or '}}' not in content:
        print(f"El template {name} no usa plantillas de Helm (falta '{{{{ ... }}}}')")
        sys.exit(1)
    if '.Values' not in content:
        print(f"El template {name} debe usar .Values")
        sys.exit(1)
PYEOF

echo "OK Tests pasaron"
exit 0
