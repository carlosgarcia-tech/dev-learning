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

def get_deployment(name, label):
    if name not in [d.get('metadata', {}).get('name') for d in docs if d['kind'] == 'Deployment']:
        print(f"Falta el Deployment '{name}'")
        sys.exit(1)
    d = [x for x in docs if x['kind'] == 'Deployment' and x.get('metadata', {}).get('name') == name][0]
    s = d.get('spec', {})
    if s.get('replicas') != 2:
        print(f"Deployment {name}: replicas debe ser 2 (es {s.get('replicas')})")
        sys.exit(1)
    if s.get('selector', {}).get('matchLabels', {}).get('app') != label:
        print(f"Deployment {name}: selector.matchLabels debe ser app={label}")
        sys.exit(1)
    tl = s.get('template', {}).get('metadata', {}).get('labels', {})
    if tl.get('app') != label:
        print(f"Deployment {name}: template.labels debe ser app={label}")
        sys.exit(1)
    return d

def get_service(name, label):
    if name not in [d.get('metadata', {}).get('name') for d in docs if d['kind'] == 'Service']:
        print(f"Falta el Service '{name}'")
        sys.exit(1)
    d = [x for x in docs if x['kind'] == 'Service' and x.get('metadata', {}).get('name') == name][0]
    if d.get('spec', {}).get('selector', {}).get('app') != label:
        print(f"Service {name}: selector debe ser app={label}")
        sys.exit(1)
    ports = d.get('spec', {}).get('ports', [])
    if not any(p.get('port') == 80 for p in ports):
        print(f"Service {name}: debe exponer el puerto 80")
        sys.exit(1)
    return d

get_deployment('frontend', 'frontend')
get_deployment('backend', 'backend')
get_service('frontend-service', 'frontend')
get_service('backend-service', 'backend')

# Debe existir el Ingress
if 'Ingress' not in kinds:
    print("Falta el recurso Ingress")
    sys.exit(1)
ing = kinds['Ingress']
if ing['metadata'].get('name') != 'app-ingress':
    print(f"Ingress: el nombre debe ser 'app-ingress' (es '{ing['metadata'].get('name')}')")
    sys.exit(1)
ispec = ing.get('spec', {})
if ispec.get('ingressClassName') != 'nginx':
    print(f"Ingress: ingressClassName debe ser 'nginx' (es '{ispec.get('ingressClassName')}')")
    sys.exit(1)

rules = ispec.get('rules', [])
if not rules:
    print("Ingress: falta definir rules")
    sys.exit(1)
hosts = [r.get('host') for r in rules]
if 'app.midominio.com' not in hosts:
    print("Ingress: falta la regla para el host 'app.midominio.com'")
    sys.exit(1)

# Recoger los paths del host correcto
paths = []
for r in rules:
    if r.get('host') == 'app.midominio.com':
        paths = r.get('http', {}).get('paths', [])
if not paths:
    print("Ingress: no hay paths definidos para app.midominio.com")
    sys.exit(1)

# Validar backend por path
def find_backend(pathval, svc):
    for p in paths:
        if p.get('path') == pathval:
            if p.get('pathType') != 'Prefix':
                print(f"Ingress: el path '{pathval}' debe ser pathType Prefix")
                sys.exit(1)
            svcname = p.get('backend', {}).get('service', {}).get('name')
            if svcname != svc:
                print(f"Ingress: el path '{pathval}' debe enrutar a {svc} (es '{svcname}')")
                sys.exit(1)
            portnum = p.get('backend', {}).get('service', {}).get('port', {}).get('number')
            if portnum != 80:
                print(f"Ingress: el path '{pathval}' debe usar port.number 80 (es {portnum})")
                sys.exit(1)
            return True
    print(f"Ingress: falta el path '{pathval}'")
    sys.exit(1)

find_backend('/', 'frontend-service')
find_backend('/api', 'backend-service')

print("OK Validación específica Ingress")
PYEOF

# Si hay cluster, aplicar y verificar
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster detectado. Aplicando manifiestos..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  sleep 3
  kubectl get deploy frontend >/dev/null 2>&1 || fail "No se encontró el Deployment frontend"
  kubectl get deploy backend >/dev/null 2>&1 || fail "No se encontró el Deployment backend"
  kubectl get svc frontend-service >/dev/null 2>&1 || fail "No se encontró el Service frontend-service"
  kubectl get svc backend-service >/dev/null 2>&1 || fail "No se encontró el Service backend-service"
  kubectl get ingress app-ingress >/dev/null 2>&1 || fail "No se encontró el Ingress app-ingress"
  kubectl delete -f "$YAML_DIR" --ignore-not-found >/dev/null 2>&1 || true
  echo "Validación en cluster OK."
fi

echo "OK Tests pasaron"
exit 0
