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

# Validaciones específicas
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

if 'Pod' not in kinds:
    print("Falta el recurso Pod")
    sys.exit(1)
pod = kinds['Pod']
if pod['metadata'].get('name') != 'app-probes':
    print(f"Pod: el nombre debe ser 'app-probes' (es '{pod['metadata'].get('name')}')")
    sys.exit(1)

containers = pod.get('spec', {}).get('containers', [])
if not containers:
    print("Pod: falta definir containers")
    sys.exit(1)
c0 = containers[0]
if c0.get('image') != 'nginx:1.25':
    print(f"Pod: la imagen debe ser 'nginx:1.25' (es '{c0.get('image')}')")
    sys.exit(1)

# Validar livenessProbe
live = c0.get('livenessProbe')
if not live:
    print("Pod: falta livenessProbe")
    sys.exit(1)
hg = live.get('httpGet')
if not hg:
    print("Pod: livenessProbe debe ser httpGet")
    sys.exit(1)
if hg.get('path') != '/':
    print(f"Pod: livenessProbe.httpGet.path debe ser '/' (es '{hg.get('path')}')")
    sys.exit(1)
if hg.get('port') != 80:
    print(f"Pod: livenessProbe.httpGet.port debe ser 80 (es '{hg.get('port')}')")
    sys.exit(1)
if live.get('initialDelaySeconds') != 10:
    print(f"Pod: livenessProbe.initialDelaySeconds debe ser 10 (es {live.get('initialDelaySeconds')})")
    sys.exit(1)
if live.get('periodSeconds') != 5:
    print(f"Pod: livenessProbe.periodSeconds debe ser 5 (es {live.get('periodSeconds')})")
    sys.exit(1)
if live.get('timeoutSeconds') != 1:
    print(f"Pod: livenessProbe.timeoutSeconds debe ser 1 (es {live.get('timeoutSeconds')})")
    sys.exit(1)
if live.get('failureThreshold') != 3:
    print(f"Pod: livenessProbe.failureThreshold debe ser 3 (es {live.get('failureThreshold')})")
    sys.exit(1)

# Validar readinessProbe
ready = c0.get('readinessProbe')
if not ready:
    print("Pod: falta readinessProbe")
    sys.exit(1)
rg = ready.get('httpGet')
if not rg:
    print("Pod: readinessProbe debe ser httpGet")
    sys.exit(1)
if rg.get('path') != '/':
    print(f"Pod: readinessProbe.httpGet.path debe ser '/' (es '{rg.get('path')}')")
    sys.exit(1)
if rg.get('port') != 80:
    print(f"Pod: readinessProbe.httpGet.port debe ser 80 (es '{rg.get('port')}')")
    sys.exit(1)
if ready.get('initialDelaySeconds') != 5:
    print(f"Pod: readinessProbe.initialDelaySeconds debe ser 5 (es {ready.get('initialDelaySeconds')})")
    sys.exit(1)
if ready.get('periodSeconds') != 5:
    print(f"Pod: readinessProbe.periodSeconds debe ser 5 (es {ready.get('periodSeconds')})")
    sys.exit(1)

print("OK Validación específica Probes")
PYEOF

# Si hay cluster, aplicar y verificar
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster detectado. Aplicando manifiestos..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  sleep 12
  kubectl get pod app-probes >/dev/null 2>&1 || fail "No se encontró el Pod app-probes"
  kubectl delete -f "$YAML_DIR" --ignore-not-found >/dev/null 2>&1 || true
  echo "Validación en cluster OK."
fi

echo "OK Tests pasaron"
exit 0
