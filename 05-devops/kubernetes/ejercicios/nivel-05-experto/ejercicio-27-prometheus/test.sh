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

# Validaciones específicas de Prometheus
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

# Deployment
if 'Deployment' not in kinds:
    print("Falta un Deployment")
    sys.exit(1)
dep = kinds['Deployment']
containers = dep.get('spec', {}).get('template', {}).get('spec', {}).get('containers', [])
if not containers:
    print("El Deployment no tiene containers")
    sys.exit(1)

# Debe exponer un puerto (containerPort)
ports = containers[0].get('ports', [])
if not ports:
    print("El container del Deployment debe exponer un puerto (containerPort)")
    sys.exit(1)
container_port = ports[0].get('containerPort')
if container_port is None:
    print("Falta containerPort en el Deployment")
    sys.exit(1)

# Service
if 'Service' not in kinds:
    print("Falta un Service")
    sys.exit(1)
svc = kinds['Service']
svc_ports = svc.get('spec', {}).get('ports', [])
if not svc_ports:
    print("El Service debe tener al menos un puerto")
    sys.exit(1)
svc_port_name = svc_ports[0].get('name')
if svc_port_name is None:
    print("El puerto del Service debe tener un 'name' (ej. metrics)")
    sys.exit(1)

# ServiceMonitor
if 'ServiceMonitor' not in kinds:
    print("Falta un ServiceMonitor")
    sys.exit(1)
sm = kinds['ServiceMonitor']
if sm.get('apiVersion') != 'monitoring.coreos.com/v1':
    print("ServiceMonitor: apiVersion debe ser 'monitoring.coreos.com/v1'")
    sys.exit(1)

# selector del ServiceMonitor debe matchear labels del Service
sm_selector = sm.get('spec', {}).get('selector', {}).get('matchLabels', {}) or {}
svc_labels = svc.get('metadata', {}).get('labels', {}) or {}
if not sm_selector:
    print("ServiceMonitor: falta spec.selector.matchLabels")
    sys.exit(1)
for k, v in sm_selector.items():
    if svc_labels.get(k) != v:
        print(f"ServiceMonitor: selector ({k}={v}) no coincide con labels del Service ({svc_labels})")
        sys.exit(1)

# endpoints: path /metrics e interval
endpoints = sm.get('spec', {}).get('endpoints', [])
if not endpoints:
    print("ServiceMonitor: falta spec.endpoints")
    sys.exit(1)
ep = endpoints[0]
if ep.get('path') != '/metrics':
    print("ServiceMonitor: endpoint.path debe ser '/metrics'")
    sys.exit(1)
if ep.get('interval') != '15s':
    print("ServiceMonitor: endpoint.interval debe ser '15s'")
    sys.exit(1)
if ep.get('port') is None:
    print("ServiceMonitor: endpoint debe tener 'port'")
    sys.exit(1)
PYEOF

# Validación opcional con cluster
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster K8s detectado, aplicando y verificando..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
fi

echo "OK Tests pasaron"
exit 0
