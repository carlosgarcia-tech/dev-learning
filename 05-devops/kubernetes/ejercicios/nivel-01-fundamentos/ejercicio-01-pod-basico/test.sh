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

# Debe existir un Pod
pods = [d for d in docs if d.get('kind') == 'Pod']
assert pods, "Debe haber un recurso de tipo Pod"

pod = pods[0]
# Nombre del Pod
assert pod['metadata']['name'] == 'nginx-pod', f"El Pod debe llamarse 'nginx-pod', es '{pod['metadata']['name']}'"

# Labels
labels = pod.get('metadata', {}).get('labels', {})
assert labels.get('app') == 'web', f"La label 'app' debe ser 'web', es '{labels.get('app')}'"
assert labels.get('env') == 'dev', f"La label 'env' debe ser 'dev', es '{labels.get('env')}'"

# Contenedores
containers = pod.get('spec', {}).get('containers', [])
assert len(containers) == 1, f"Debe haber exactamente 1 contenedor, hay {len(containers)}"

c = containers[0]
assert c.get('name') == 'web', f"El contenedor debe llamarse 'web', es '{c.get('name')}'"
assert c.get('image') == 'nginx:alpine', f"La imagen debe ser 'nginx:alpine', es '{c.get('image')}'"

# Puerto 80
ports = c.get('ports', [])
assert any(p.get('containerPort') == 80 for p in ports), "El contenedor debe exponer el puerto 80"
PYEOF

echo "OK Tests pasaron"
exit 0
