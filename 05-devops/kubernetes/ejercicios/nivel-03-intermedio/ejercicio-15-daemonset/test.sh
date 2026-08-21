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

if 'DaemonSet' not in kinds:
    print("Falta el recurso DaemonSet")
    sys.exit(1)
ds = kinds['DaemonSet']
if ds['metadata'].get('name') != 'log-collector':
    print(f"DaemonSet: el nombre debe ser 'log-collector' (es '{ds['metadata'].get('name')}')")
    sys.exit(1)

sspec = ds.get('spec', {})
selector = sspec.get('selector', {}).get('matchLabels', {})
if selector.get('app') != 'log-collector':
    print("DaemonSet: selector.matchLabels debe ser app=log-collector")
    sys.exit(1)

tmpl = sspec.get('template', {})
tmpl_labels = tmpl.get('metadata', {}).get('labels', {})
if tmpl_labels.get('app') != 'log-collector':
    print("DaemonSet: template.metadata.labels debe ser app=log-collector")
    sys.exit(1)

podspec = tmpl.get('spec', {})
containers = podspec.get('containers', [])
if not containers:
    print("DaemonSet: falta definir containers")
    sys.exit(1)
c0 = containers[0]
if c0.get('image') != 'fluent/fluentd:v1.16':
    print(f"DaemonSet: la imagen debe ser 'fluent/fluentd:v1.16' (es '{c0.get('image')}')")
    sys.exit(1)

# Validar resources requests y limits
res = c0.get('resources', {})
if 'requests' not in res:
    print("DaemonSet: falta resources.requests")
    sys.exit(1)
if 'limits' not in res:
    print("DaemonSet: falta resources.limits")
    sys.exit(1)
req = res['requests']
lim = res['limits']
for k in ('cpu', 'memory'):
    if k not in req:
        print(f"DaemonSet: falta resources.requests.{k}")
        sys.exit(1)
    if k not in lim:
        print(f"DaemonSet: falta resources.limits.{k}")
        sys.exit(1)

# Validar los dos volúmenes hostPath
volumes = podspec.get('volumes', [])
vol_by_name = {v.get('name'): v for v in volumes}
needed = {
    'varlog': '/var/log',
    'varlibdockercontainers': '/var/lib/docker/containers',
}
for vname, path in needed.items():
    if vname not in vol_by_name:
        print(f"DaemonSet: falta el volume '{vname}'")
        sys.exit(1)
    hp = vol_by_name[vname].get('hostPath', {})
    if hp.get('path') != path:
        print(f"DaemonSet: el volume '{vname}' debe tener hostPath.path='{path}' (es '{hp.get('path')}')")
        sys.exit(1)

# Validar volumeMounts readOnly
mounts = c0.get('volumeMounts', [])
mount_by_name = {m.get('name'): m for m in mounts}
for vname, path in needed.items():
    if vname not in mount_by_name:
        print(f"DaemonSet: falta el volumeMount '{vname}'")
        sys.exit(1)
    m = mount_by_name[vname]
    if m.get('readOnly') is not True:
        print(f"DaemonSet: el volumeMount '{vname}' debe ser readOnly: true")
        sys.exit(1)
expected_mp = path
if m.get('mountPath') != expected_mp:
    print(f"DaemonSet: el volumeMount '{vname}' debe montarse en '{expected_mp}' (es '{m.get('mountPath')}')")
    sys.exit(1)

print("OK Validación específica DaemonSet")
PYEOF

# Si hay cluster, aplicar y verificar
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster detectado. Aplicando manifiestos..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  sleep 3
  kubectl get daemonset log-collector >/dev/null 2>&1 || fail "No se encontró el DaemonSet log-collector"
  kubectl delete -f "$YAML_DIR" --ignore-not-found >/dev/null 2>&1 || true
  echo "Validación en cluster OK."
fi

echo "OK Tests pasaron"
exit 0
