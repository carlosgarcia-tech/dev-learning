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

# Debe existir un Pod llamado web-logs
pods = [d for d in docs if d.get('kind') == 'Pod']
assert pods, "Debe haber un recurso de tipo Pod"
pod = pods[0]
assert pod['metadata']['name'] == 'web-logs', f"El Pod debe llamarse 'web-logs', es '{pod['metadata']['name']}'"

# Exactamente 2 contenedores
containers = pod.get('spec', {}).get('containers', [])
assert len(containers) == 2, f"Debe haber exactamente 2 contenedores, hay {len(containers)}"

by_name = {c.get('name'): c for c in containers}
assert 'nginx' in by_name, "Falta el contenedor 'nginx'"
assert 'logger' in by_name, "Falta el contenedor 'logger'"

# nginx
nginx = by_name['nginx']
assert nginx.get('image') == 'nginx:alpine', f"nginx debe usar imagen 'nginx:alpine', es '{nginx.get('image')}'"
ports = nginx.get('ports', [])
assert any(p.get('containerPort') == 80 for p in ports), "nginx debe exponer el puerto 80"

# logger
logger = by_name['logger']
assert logger.get('image') == 'busybox', f"logger debe usar imagen 'busybox', es '{logger.get('image')}'"

# Volumen compartido
volumes = pod.get('spec', {}).get('volumes', [])
vol_names = [v.get('name') for v in volumes]
assert 'shared-logs' in vol_names, "Falta el volumen 'shared-logs'"
shared = next(v for v in volumes if v.get('name') == 'shared-logs')
assert 'emptyDir' in shared, "El volumen 'shared-logs' debe ser de tipo emptyDir"

# Ambos contenedores montan shared-logs en /var/log/nginx
for cname in ('nginx', 'logger'):
    mounts = by_name[cname].get('volumeMounts', [])
    found = any(m.get('name') == 'shared-logs' and m.get('mountPath') == '/var/log/nginx' for m in mounts)
    assert found, f"El contenedor '{cname}' debe montar 'shared-logs' en '/var/log/nginx'"
PYEOF

echo "OK Tests pasaron"
exit 0
