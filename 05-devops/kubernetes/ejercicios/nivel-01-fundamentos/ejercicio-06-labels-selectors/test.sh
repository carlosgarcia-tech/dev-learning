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

# Deployment
deploys = [d for d in docs if d.get('kind') == 'Deployment']
assert deploys, "Debe haber un recurso de tipo Deployment"
d = deploys[0]
assert d['metadata']['name'] == 'web-deploy', f"El Deployment debe llamarse 'web-deploy', es '{d['metadata']['name']}'"
replicas = d.get('spec', {}).get('replicas')
assert replicas == 2, f"El Deployment debe tener 2 réplicas, tiene {replicas}"

# Labels del template
tmpl_labels = d.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {})
assert tmpl_labels.get('app') == 'web', f"El template debe tener label app=web, es {tmpl_labels.get('app')}"
assert tmpl_labels.get('tier') == 'frontend', f"El template debe tener label tier=frontend, es {tmpl_labels.get('tier')}"

# Selector del Deployment coincide con template labels
selector = d.get('spec', {}).get('selector', {}).get('matchLabels', {})
assert selector, "El Deployment debe tener selector.matchLabels"
assert selector == tmpl_labels, f"El selector {selector} no coincide con las labels del template {tmpl_labels}"

# Contenedor del Deployment
containers = d.get('spec', {}).get('template', {}).get('spec', {}).get('containers', [])
assert len(containers) >= 1, "El template debe tener al menos un contenedor"
c = containers[0]
assert c.get('image') == 'nginx:alpine', f"La imagen debe ser 'nginx:alpine', es '{c.get('image')}'"

# Service
services = [d for d in docs if d.get('kind') == 'Service']
assert services, "Debe haber un recurso de tipo Service"
s = services[0]
assert s['metadata']['name'] == 'web-service', f"El Service debe llamarse 'web-service', es '{s['metadata']['name']}'"

# Tipo ClusterIP
stype = s.get('spec', {}).get('type')
assert stype == 'ClusterIP', f"El Service debe ser de tipo ClusterIP, es '{stype}'"

# Selector del Service -> app=web
svc_selector = s.get('spec', {}).get('selector', {})
assert svc_selector.get('app') == 'web', f"El Service debe seleccionar app=web, es {svc_selector}"

# Puertos
ports = s.get('spec', {}).get('ports', [])
assert ports, "El Service debe definir al menos un puerto"
p = ports[0]
assert p.get('port') == 80, f"El Service debe tener port=80, es {p.get('port')}"
assert p.get('targetPort') == 80, f"El Service debe tener targetPort=80, es {p.get('targetPort')}"
PYEOF

echo "OK Tests pasaron"
exit 0
