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

# Validaciones específicas del RollingUpdate
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

kinds = {d['kind']: d for d in docs}

# Debe existir un Deployment
if 'Deployment' not in kinds:
    print("Falta un recurso Deployment")
    sys.exit(1)
dep = kinds['Deployment']
spec = dep.get('spec', {})

# Estrategia RollingUpdate
strategy = spec.get('strategy', {})
if strategy.get('type') != 'RollingUpdate':
    print("El Deployment debe usar strategy.type RollingUpdate")
    sys.exit(1)
ru = strategy.get('rollingUpdate', {})
if 'maxSurge' not in ru or 'maxUnavailable' not in ru:
    print("El Deployment debe definir rollingUpdate.maxSurge y rollingUpdate.maxUnavailable")
    sys.exit(1)
if ru.get('maxSurge') != 1:
    print(f"rollingUpdate.maxSurge debe ser 1 (encontrado: {ru.get('maxSurge')})")
    sys.exit(1)
if ru.get('maxUnavailable') != 0:
    print(f"rollingUpdate.maxUnavailable debe ser 0 (encontrado: {ru.get('maxUnavailable')})")
    sys.exit(1)

# replicas = 3
if spec.get('replicas') != 3:
    print(f"El Deployment debe tener 3 réplicas (encontrado: {spec.get('replicas')})")
    sys.exit(1)

# selector coincide con template labels
selector_labels = spec.get('selector', {}).get('matchLabels', {})
template_labels = spec.get('template', {}).get('metadata', {}).get('labels', {})
if not selector_labels:
    print("El Deployment debe definir selector.matchLabels")
    sys.exit(1)
for k, v in selector_labels.items():
    if template_labels.get(k) != v:
        print(f"selector.matchLabels ({k}={v}) no coincide con template.metadata.labels")
        sys.exit(1)

# Anotación change-cause presente
annotations = dep.get('metadata', {}).get('annotations', {})
if 'kubernetes.io/change-cause' not in annotations:
    print("El Deployment debe incluir la anotación 'kubernetes.io/change-cause'")
    sys.exit(1)
PYEOF

# Validación opcional con cluster K8s
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  ns="ej12-$(date +%s | tail -c 6)"
  kubectl create namespace "$ns" >/dev/null 2>&1
  if kubectl apply -f "$YAML_DIR" -n "$ns" >/dev/null 2>&1; then
    # Esperar rollout
    kubectl rollout status deployment/web -n "$ns" --timeout=60s >/dev/null 2>&1 || true
    # Comprobar historial
    kubectl rollout history deployment/web -n "$ns" >/dev/null 2>&1 || true
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
  else
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
    fail "kubectl apply falló al aplicar los manifiestos"
  fi
fi

echo "OK Tests pasaron"
exit 0
