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

# Validaciones específicas de affinity y tolerations
python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os, json
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
    print("Falta un Deployment")
    sys.exit(1)
dep = kinds['Deployment']

if dep.get('spec', {}).get('replicas', 1) < 3:
    print("El Deployment debe tener al menos 3 replicas")
    sys.exit(1)

podspec = dep.get('spec', {}).get('template', {}).get('spec', {})

# nodeSelector o nodeAffinity que referencie disktype=ssd
ns = podspec.get('nodeSelector', {})
affinity = podspec.get('affinity', {}) or {}
na = affinity.get('nodeAffinity', {})

has_ssd = False
if ns:
    if ns.get('disktype') == 'ssd':
        has_ssd = True
if na:
    # busqueda permisiva: que aparezca 'ssd' asociado a 'disktype' en nodeAffinity
    blob = json.dumps(na)
    if 'ssd' in blob and 'disktype' in blob:
        has_ssd = True
if not has_ssd:
    print("Falta nodeSelector o nodeAffinity que prefiera disktype=ssd")
    sys.exit(1)

# tolerations
tolerations = podspec.get('tolerations', [])
if not tolerations:
    print("Falta spec.tolerations")
    sys.exit(1)
found_gpu = False
for t in tolerations:
    if t.get('key') == 'dedicated' and t.get('value') == 'gpu' and t.get('effect') == 'NoSchedule':
        found_gpu = True
        break
if not found_gpu:
    print("Falta toleration para dedicated=gpu:NoSchedule")
    sys.exit(1)

# podAntiAffinity
paa = affinity.get('podAntiAffinity', {})
if not paa:
    print("Falta spec.affinity.podAntiAffinity")
    sys.exit(1)
preferred = paa.get('preferredDuringSchedulingIgnoredDuringExecution', [])
if not preferred:
    print("podAntiAffinity debe usar preferredDuringSchedulingIgnoredDuringExecution")
    sys.exit(1)
terms = [p.get('podAffinityTerm', {}) for p in preferred]
has_hostname = any(t.get('topologyKey') == 'kubernetes.io/hostname' for t in terms)
if not has_hostname:
    print("podAntiAffinity debe usar topologyKey: kubernetes.io/hostname")
    sys.exit(1)
PYEOF

# Validación opcional con cluster
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster K8s detectado, aplicando y verificando..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
fi

echo "OK Tests pasaron"
exit 0
