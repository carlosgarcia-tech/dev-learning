#!/usr/bin/env bash
# Nota: requiere un cluster K8s (kind/minikube) para validación completa; sin cluster valida los YAML.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

# Estructura de directorios esperada
[ -d base ] || fail "Falta el directorio base/"
[ -d overlay ] || fail "Falta el directorio overlay/"
[ -f base/kustomization.yaml ] || fail "Falta base/kustomization.yaml"
[ -f base/deployment.yaml ] || fail "Falta base/deployment.yaml"
[ -f base/service.yaml ] || fail "Falta base/service.yaml"
[ -f overlay/kustomization.yaml ] || fail "Falta overlay/kustomization.yaml"

# Validar todos los YAML con python3 yaml.safe_load
all_yaml="base/kustomization.yaml base/deployment.yaml base/service.yaml overlay/kustomization.yaml"
for f in $all_yaml; do
  python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null || fail "YAML inválido: $f"
done

# Validaciones de estructura (base + overlay)
python3 - <<'PYEOF' || exit 1
import yaml, sys

errors = []

def load(path):
    with open(path) as fh:
        return yaml.safe_load(fh)

# --- base/kustomization.yaml ---
bk = load('base/kustomization.yaml')
for field in ('apiVersion', 'kind', 'metadata', 'resources'):
    pass  # kustomization no requiere metadata
if bk.get('apiVersion') != 'kustomize.config.k8s.io/v1beta1':
    errors.append("base/kustomization.yaml: apiVersion debe ser 'kustomize.config.k8s.io/v1beta1'")
if bk.get('kind') != 'Kustomization':
    errors.append("base/kustomization.yaml: kind debe ser 'Kustomization'")
if 'resources' not in bk or not isinstance(bk['resources'], list):
    errors.append("base/kustomization.yaml: falta 'resources' (lista)")
else:
    if 'deployment.yaml' not in bk['resources']:
        errors.append("base/kustomization.yaml: resources debe incluir 'deployment.yaml'")
    if 'service.yaml' not in bk['resources']:
        errors.append("base/kustomization.yaml: resources debe incluir 'service.yaml'")
if 'commonLabels' not in bk:
    errors.append("base/kustomization.yaml: falta 'commonLabels'")

# --- base/deployment.yaml ---
bd = load('base/deployment.yaml')
if bd.get('kind') != 'Deployment':
    errors.append("base/deployment.yaml: kind debe ser 'Deployment'")
if bd.get('metadata', {}).get('name') is None:
    errors.append("base/deployment.yaml: falta 'metadata.name'")

# --- base/service.yaml ---
bs = load('base/service.yaml')
if bs.get('kind') != 'Service':
    errors.append("base/service.yaml: kind debe ser 'Service'")
if bs.get('metadata', {}).get('name') is None:
    errors.append("base/service.yaml: falta 'metadata.name'")

# --- overlay/kustomization.yaml ---
ok = load('overlay/kustomization.yaml')
if ok.get('apiVersion') != 'kustomize.config.k8s.io/v1beta1':
    errors.append("overlay/kustomization.yaml: apiVersion debe ser 'kustomize.config.k8s.io/v1beta1'")
if ok.get('kind') != 'Kustomization':
    errors.append("overlay/kustomization.yaml: kind debe ser 'Kustomization'")
if 'resources' not in ok or not isinstance(ok['resources'], list):
    errors.append("overlay/kustomization.yaml: falta 'resources' (lista)")
elif '../base' not in ok['resources']:
    errors.append("overlay/kustomization.yaml: resources debe referenciar '../base'")
if 'commonLabels' not in ok:
    errors.append("overlay/kustomization.yaml: falta 'commonLabels'")
if 'replicas' not in ok or not isinstance(ok['replicas'], list):
    errors.append("overlay/kustomization.yaml: falta 'replicas' (lista)")
else:
    if not any(r.get('name') == 'api' and r.get('count') == 5 for r in ok['replicas']):
        errors.append("overlay/kustomization.yaml: replicas debe escalar 'api' a 5")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
PYEOF

# Validación opcional con cluster
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster K8s detectado, renderizando kustomize (no aplica cambios)..."
  kubectl kustomize overlay/ >/dev/null 2>&1 || fail "kubectl kustomize overlay/ falló"
fi

echo "OK Tests pasaron"
exit 0
