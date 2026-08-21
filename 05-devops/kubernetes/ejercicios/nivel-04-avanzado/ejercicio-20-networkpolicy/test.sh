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

# Validaciones específicas de la NetworkPolicy
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

# Deben existir frontend, backend y NetworkPolicy
for k in ('Deployment', 'Service', 'NetworkPolicy'):
    if k not in kinds:
        print(f"Falta un recurso {k}")
        sys.exit(1)

# Debe haber deployments y services con nombres frontend y backend
dep_names = set()
svc_names = set()
for d in docs:
    if d['kind'] == 'Deployment':
        dep_names.add(d['metadata']['name'])
    if d['kind'] == 'Service':
        svc_names.add(d['metadata']['name'])
for name in ('frontend', 'backend'):
    if name not in dep_names:
        print(f"Falta el Deployment '{name}'")
        sys.exit(1)
    if name not in svc_names:
        print(f"Falta el Service '{name}'")
        sys.exit(1)

# Validar la NetworkPolicy
np = kinds['NetworkPolicy']
spec = np.get('spec', {})

# Debe seleccionar el backend
ps = spec.get('podSelector', {}).get('matchLabels', {})
if ps.get('app') != 'backend':
    print("NetworkPolicy.podSelector debe seleccionar app: backend")
    sys.exit(1)

# policyTypes debe contener Ingress
if 'Ingress' not in spec.get('policyTypes', []):
    print("NetworkPolicy debe declarar policyTypes con Ingress")
    sys.exit(1)

# ingress solo debe permitir desde app: frontend
ingress = spec.get('ingress', [])
if not ingress:
    print("NetworkPolicy debe definir reglas ingress")
    sys.exit(1)
allowed = False
for rule in ingress:
    for frm in rule.get('from', []):
        labels = frm.get('podSelector', {}).get('matchLabels', {})
        if labels.get('app') == 'frontend':
            allowed = True
if not allowed:
    print("NetworkPolicy.ingress debe permitir solo desde pods app: frontend")
    sys.exit(1)

# No debe haber ingress 'from: []' vacío que permita todo
for rule in ingress:
    if 'from' in rule and rule['from'] == []:
        print("NetworkPolicy.ingress.from vacio permite todo el trafico (no es seguro)")
        sys.exit(1)
PYEOF

echo "OK Tests pasaron"
exit 0
