#!/usr/bin/env bash
# Nota: requiere un cluster K8s (kind/minikube) para validación completa; sin cluster valida los YAML.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Determinar directorio de YAMLs: '.' si hay, sino 'solucion'
YAML_DIR="."
if ! ls *.yaml >/dev/null 2>&1; then
  YAML_DIR="solucion"
fi

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

# 1. Validar que hay YAMLs
yaml_files=$(find "$YAML_DIR" -maxdepth 1 -name '*.yaml' -type f 2>/dev/null | sort)
if [ -z "$yaml_files" ]; then
  fail "No se encontraron archivos *.yaml en $YAML_DIR/"
fi

# 2. Validar sintaxis YAML con python3
for f in $yaml_files; do
  python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null || fail "YAML inválido: $f"
done

# 3. Validar campos requeridos (apiVersion, kind, metadata.name)
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

# 4. Validaciones específicas del ejercicio
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

# Debe existir un Deployment llamado app-deploy
deploys = [d for d in docs if d.get('kind') == 'Deployment']
assert deploys, "Debe haber un recurso de tipo Deployment"
d = deploys[0]
assert d['metadata']['name'] == 'app-deploy', f"El Deployment debe llamarse 'app-deploy', es '{d['metadata']['name']}'"
replicas = d.get('spec', {}).get('replicas')
assert replicas == 2, f"El Deployment debe tener 2 réplicas, tiene {replicas}"

# Selector debe coincidir con template labels
selector = d.get('spec', {}).get('selector', {}).get('matchLabels', {})
tmpl_labels = d.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {})
assert selector, "El Deployment debe tener selector.matchLabels"
assert tmpl_labels, "El template del Pod debe tener labels"
assert selector == tmpl_labels, f"El selector {selector} no coincide con las labels del template {tmpl_labels}"

# Debe existir un Pod llamado app-pod
pods = [d for d in docs if d.get('kind') == 'Pod']
assert pods, "Debe haber un recurso de tipo Pod"
p = pods[0]
assert p['metadata']['name'] == 'app-pod', f"El Pod debe llamarse 'app-pod', es '{p['metadata']['name']}'"
containers = p.get('spec', {}).get('containers', [])
assert len(containers) >= 1, "El Pod debe tener al menos un contenedor"
PYEOF

echo "OK Tests pasaron"
exit 0
