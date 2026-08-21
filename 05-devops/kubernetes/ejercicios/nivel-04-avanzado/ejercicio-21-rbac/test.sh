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

# Validaciones específicas de RBAC
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

# Deben existir ServiceAccount, Role y RoleBinding
for k in ('ServiceAccount', 'Role', 'RoleBinding'):
    if k not in kinds:
        print(f"Falta un recurso {k}")
        sys.exit(1)

sa = kinds['ServiceAccount']
role = kinds['Role']
rb = kinds['RoleBinding']

# Todos deben llamarse pod-reader
for r in (sa, role, rb):
    if r['metadata']['name'] != 'pod-reader':
        print(f"El recurso {r['kind']} debe llamarse 'pod-reader'")
        sys.exit(1)

# Validar Role: rules con apiGroups, resources y verbs
rules = role.get('rules', [])
if not rules:
    print("El Role debe definir rules")
    sys.exit(1)
rule = rules[0]
if "" not in rule.get('apiGroups', []):
    print("El Role debe conceder permisos sobre el apiGroup '' (pods)")
    sys.exit(1)
if "pods" not in rule.get('resources', []):
    print("El Role debe conceder permisos sobre el recurso 'pods'")
    sys.exit(1)
verbs = rule.get('verbs', [])
for v in ('get', 'list', 'watch'):
    if v not in verbs:
        print(f"El Role debe incluir el verbo '{v}'")
        sys.exit(1)

# Validar RoleBinding: subjects y roleRef
subjects = rb.get('subjects', [])
if not subjects:
    print("El RoleBinding debe definir subjects")
    sys.exit(1)
subj = subjects[0]
if subj.get('kind') != 'ServiceAccount':
    print("RoleBinding.subjects[].kind debe ser ServiceAccount")
    sys.exit(1)
if subj.get('name') != 'pod-reader':
    print("RoleBinding.subjects[].name debe ser 'pod-reader'")
    sys.exit(1)

roleRef = rb.get('roleRef', {})
if roleRef.get('kind') != 'Role':
    print("RoleBinding.roleRef.kind debe ser Role")
    sys.exit(1)
if roleRef.get('name') != 'pod-reader':
    print("RoleBinding.roleRef.name debe ser 'pod-reader'")
    sys.exit(1)
if roleRef.get('apiGroup') != 'rbac.authorization.k8s.io':
    print("RoleBinding.roleRef.apiGroup debe ser 'rbac.authorization.k8s.io'")
    sys.exit(1)
PYEOF

echo "OK Tests pasaron"
exit 0
