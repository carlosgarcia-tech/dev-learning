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

# Validaciones específicas del volumen emptyDir
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

# Debe existir un Pod
if 'Pod' not in kinds:
    print("Falta un recurso Pod")
    sys.exit(1)
pod = kinds['Pod']

# Debe tener al menos 2 contenedores
containers = pod.get('spec', {}).get('containers', [])
if len(containers) < 2:
    print("El Pod debe tener al menos 2 contenedores")
    sys.exit(1)

# Debe existir un volumen emptyDir
volumes = pod.get('spec', {}).get('volumes', [])
empty_vols = [v.get('name') for v in volumes if 'emptyDir' in v]
if not empty_vols:
    print("El Pod debe definir un volumen de tipo emptyDir")
    sys.exit(1)
shared_vol = empty_vols[0]

# Todos los contenedores deben montar ese volumen
for c in containers:
    mounts = c.get('volumeMounts', [])
    names = [m.get('name') for m in mounts]
    if shared_vol not in names:
        print(f"El contenedor '{c.get('name')}' no monta el volumen '{shared_vol}'")
        sys.exit(1)
PYEOF

# Validación opcional con cluster K8s
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  ns="ej11-$(date +%s | tail -c 6)"
  kubectl create namespace "$ns" >/dev/null 2>&1
  if kubectl apply -f "$YAML_DIR" -n "$ns" >/dev/null 2>&1; then
    kubectl get pod shared-volume-pod -n "$ns" >/dev/null 2>&1 || true
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
  else
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
    fail "kubectl apply falló al aplicar los manifiestos"
  fi
fi

echo "OK Tests pasaron"
exit 0
