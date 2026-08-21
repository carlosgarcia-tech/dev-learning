#!/usr/bin/env bash
# Nota: requiere un cluster K8s (kind/minikube) para validación completa; sin cluster valida los YAML.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

YAML_DIR="."
if ! ls *.yaml >/dev/null 2>&1; then
  YAML_DIR="solucion"
fi

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

yaml_files=$(find "$YAML_DIR" -maxdepth 1 -name '*.yaml' -type f 2>/dev/null | sort)
if [ -z "$yaml_files" ]; then
  fail "No se encontraron archivos *.yaml en $YAML_DIR/"
fi

for f in $yaml_files; do
  python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null || fail "YAML inválido: $f"
done

python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os
yaml_dir = sys.argv[1]
files = sorted(glob.glob(os.path.join(yaml_dir, '*.yaml')))
for f in files:
    with open(f) as fh:
        for doc in yaml.safe_load_all(fh):
            if doc is None:
                continue
            for field in ('apiVersion', 'kind', 'metadata'):
                if field not in doc:
                    print(f"Falta '{field}' en {f}")
                    sys.exit(1)
            if 'name' not in doc.get('metadata', {}):
                print(f"Falta 'metadata.name' en {f}")
                sys.exit(1)
PYEOF

# Validaciones específicas del canary
python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os
yaml_dir = sys.argv[1]
files = sorted(glob.glob(os.path.join(yaml_dir, '*.yaml')))
docs = []
for f in files:
    with open(f) as fh:
        for doc in yaml.safe_load_all(fh):
            if doc is not None:
                docs.append(doc)

kinds = {}
for d in docs:
    kinds.setdefault(d['kind'], []).append(d)

# Debe haber al menos 2 Deployments
deps = kinds.get('Deployment', [])
if len(deps) < 2:
    print("Se necesitan al menos 2 Deployments (stable y canary)")
    sys.exit(1)

# Buscar por nombre o por label track
stable = None
canary = None
for d in deps:
    name = d.get('metadata', {}).get('name', '')
    labels = d.get('metadata', {}).get('labels', {}) or {}
    tmpl_labels = d.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {}) or {}
    all_labels = {**labels, **tmpl_labels}
    if 'stable' in name or all_labels.get('track') == 'stable':
        stable = d
    if 'canary' in name or all_labels.get('track') == 'canary':
        canary = d

if stable is None:
    print("No se encontró el Deployment stable (nombre 'stable' o label track=stable)")
    sys.exit(1)
if canary is None:
    print("No se encontró el Deployment canary (nombre 'canary' o label track=canary)")
    sys.exit(1)

sr = stable.get('spec', {}).get('replicas', 1)
cr = canary.get('spec', {}).get('replicas', 1)

# Proporción 90/10 => 9/1 (o múltiplos). Comprobamos que stable tenga muchas más réplicas.
if sr + cr == 0:
    print("Las réplicas totales no pueden ser 0")
    sys.exit(1)

# Aceptar 9/1 exactamente o la proporción 90/10 con múltiplos (ej. 18/2, 27/3)
total = sr + cr
ratio_canary = cr / total
# canary debe ser aprox 10% (0.09 - 0.11)
if not (0.05 <= ratio_canary <= 0.15):
    print(f"La proporción canary debe ser ~10% (90/10). Actual: stable={sr}, canary={cr} ({ratio_canary:.0%})")
    sys.exit(1)

# Ambos deben compartir el label app (el Service los selecciona por app)
def get_app(d):
    tmpl = d.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {}) or {}
    return tmpl.get('app')

if get_app(stable) != get_app(canary):
    print("Ambos Deployments deben tener el mismo label 'app' en el template")
    sys.exit(1)

# Debe existir un Service que seleccione por app
svcs = kinds.get('Service', [])
if not svcs:
    print("Falta un Service")
    sys.exit(1)
svc = svcs[0]
sel = svc.get('spec', {}).get('selector', {}) or {}
if 'app' not in sel:
    print("El Service debe seleccionar por 'app'")
    sys.exit(1)
if sel.get('app') != get_app(stable):
    print("El selector del Service no coincide con el label 'app' de los Deployments")
    sys.exit(1)
PYEOF

# Validación opcional con cluster
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster K8s detectado, aplicando y verificando..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  kubectl get deploy api-stable api-canary >/dev/null 2>&1 || fail "No se encontraron los deployments"
fi

echo "OK Tests pasaron"
exit 0
