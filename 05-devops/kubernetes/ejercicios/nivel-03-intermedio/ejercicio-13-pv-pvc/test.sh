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

# Debe existir un PersistentVolume
if 'PersistentVolume' not in kinds:
    print("Falta el recurso PersistentVolume")
    sys.exit(1)
pv = kinds['PersistentVolume']
spec = pv.get('spec', {})
cap = spec.get('capacity', {}).get('storage', '')
if cap != '2Gi':
    print(f"PersistentVolume: capacity.storage debe ser '2Gi' (es '{cap}')")
    sys.exit(1)
if 'ReadWriteOnce' not in spec.get('accessModes', []):
    print("PersistentVolume: falta accessMode ReadWriteOnce")
    sys.exit(1)
hp = spec.get('hostPath', {})
if hp.get('path') != '/mnt/datos':
    print(f"PersistentVolume: hostPath.path debe ser '/mnt/datos' (es '{hp.get('path')}')")
    sys.exit(1)

# Debe existir un PersistentVolumeClaim
if 'PersistentVolumeClaim' not in kinds:
    print("Falta el recurso PersistentVolumeClaim")
    sys.exit(1)
pvc = kinds['PersistentVolumeClaim']
pspec = pvc.get('spec', {})
req = pspec.get('resources', {}).get('requests', {}).get('storage', '')
if req != '2Gi':
    print(f"PersistentVolumeClaim: requests.storage debe ser '2Gi' (es '{req}')")
    sys.exit(1)
if 'ReadWriteOnce' not in pspec.get('accessModes', []):
    print("PersistentVolumeClaim: falta accessMode ReadWriteOnce")
    sys.exit(1)

# Debe existir un Pod que monte el PVC en /usr/share/nginx/html
if 'Pod' not in kinds:
    print("Falta el recurso Pod")
    sys.exit(1)
pod = kinds['Pod']
podspec = pod.get('spec', {})
volumes = podspec.get('volumes', [])
pvc_vol = [v for v in volumes if v.get('persistentVolumeClaim', {}).get('claimName') == 'pvc-datos']
if not pvc_vol:
    print("Pod: no hay volume que use persistentVolumeClaim.claimName=pvc-datos")
    sys.exit(1)
vol_name = pvc_vol[0]['name']
containers = podspec.get('containers', [])
found_mount = False
for c in containers:
    for vm in c.get('volumeMounts', []):
        if vm.get('name') == vol_name and vm.get('mountPath') == '/usr/share/nginx/html':
            found_mount = True
if not found_mount:
    print("Pod: falta volumeMount del PVC en /usr/share/nginx/html")
    sys.exit(1)
imgs = [c.get('image', '') for c in containers]
if not any('nginx' in i for i in imgs):
    print("Pod: la imagen debe contener 'nginx'")
    sys.exit(1)

print("OK Validación específica PV/PVC/Pod")
PYEOF

# Si hay cluster, aplicar y verificar
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster detectado. Aplicando manifiestos..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  sleep 2
  kubectl get pv pv-datos >/dev/null 2>&1 || fail "No se encontró el PV pv-datos"
  kubectl get pvc pvc-datos >/dev/null 2>&1 || fail "No se encontró el PVC pvc-datos"
  kubectl get pod app-pv >/dev/null 2>&1 || fail "No se encontró el Pod app-pv"
  # Limpieza
  kubectl delete -f "$YAML_DIR" --ignore-not-found >/dev/null 2>&1 || true
  echo "Validación en cluster OK."
fi

echo "OK Tests pasaron"
exit 0
