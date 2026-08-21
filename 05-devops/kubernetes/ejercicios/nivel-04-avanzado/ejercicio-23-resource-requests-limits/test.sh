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

# Validaciones específicas de resources
python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os, re
yaml_dir = sys.argv[1]
files = sorted(glob.glob(os.path.join(yaml_dir, '*.yaml')))
docs = []
for f in files:
    with open(f) as fh:
        for doc in yaml.safe_load_all(fh):
            if doc is not None:
                docs.append(doc)

kinds = {d['kind']: d for d in docs}
if 'Deployment' not in kinds:
    print("Falta un recurso Deployment")
    sys.exit(1)
dep = kinds['Deployment']

# Al menos 3 replicas
if dep.get('spec', {}).get('replicas', 1) < 3:
    print("El Deployment debe tener al menos 3 replicas")
    sys.exit(1)

containers = dep.get('spec', {}).get('template', {}).get('spec', {}).get('containers', [])
if not containers:
    print("El Deployment no tiene containers")
    sys.exit(1)

def cpu_to_millicores(v):
    if v is None:
        return None
    if isinstance(v, (int, float)):
        return int(v * 1000)
    s = str(v)
    if s.endswith('m'):
        return int(s[:-1])
    return int(float(s) * 1000)

def mem_to_mib(v):
    if v is None:
        return None
    s = str(v)
    m = re.match(r'^(\d+(?:\.\d+)?)(Ki|Mi|Gi|Ti)?$', s)
    if not m:
        return None
    num = float(m.group(1))
    unit = m.group(2)
    if unit == 'Ki':
        return num / 1024.0
    if unit == 'Mi':
        return num
    if unit == 'Gi':
        return num * 1024.0
    if unit == 'Ti':
        return num * 1024.0 * 1024.0
    # sin unidad: bytes
    return num / (1024.0 * 1024.0)

res = containers[0].get('resources', {})
req = res.get('requests', {})
lim = res.get('limits', {})

for key in ('cpu', 'memory'):
    if key not in req:
        print(f"El container debe definir resources.requests.{key}")
        sys.exit(1)
    if key not in lim:
        print(f"El container debe definir resources.limits.{key}")
        sys.exit(1)

# limits.cpu >= requests.cpu
rc = cpu_to_millicores(req['cpu']); lc = cpu_to_millicores(lim['cpu'])
if rc is None or lc is None or lc < rc:
    print(f"limits.cpu ({lim['cpu']}) debe ser >= requests.cpu ({req['cpu']})")
    sys.exit(1)

# limits.memory >= requests.memory
rm = mem_to_mib(req['memory']); lm = mem_to_mib(lim['memory'])
if rm is None or lm is None or lm < rm:
    print(f"limits.memory ({lim['memory']}) debe ser >= requests.memory ({req['memory']})")
    sys.exit(1)
PYEOF

echo "OK Tests pasaron"
exit 0
