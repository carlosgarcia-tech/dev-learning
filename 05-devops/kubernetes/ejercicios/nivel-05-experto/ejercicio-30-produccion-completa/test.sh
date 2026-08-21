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

# Validaciones específicas de producción completa
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

kinds = {}
for d in docs:
    kinds.setdefault(d['kind'], []).append(d)

errors = []

# 1. Deployment: 3 réplicas, probes y resources
deps = kinds.get('Deployment', [])
if not deps:
    errors.append("Falta un Deployment")
else:
    dep = deps[0]
    if dep.get('spec', {}).get('replicas', 1) < 3:
        errors.append("El Deployment debe tener al menos 3 replicas")
    containers = dep.get('spec', {}).get('template', {}).get('spec', {}).get('containers', [])
    if not containers:
        errors.append("El Deployment no tiene containers")
    else:
        c = containers[0]
        res = c.get('resources', {})
        if 'requests' not in res or 'limits' not in res:
            errors.append("El container debe definir resources.requests y resources.limits")
        else:
            for k in ('cpu', 'memory'):
                if k not in res.get('requests', {}):
                    errors.append(f"Falta resources.requests.{k}")
                if k not in res.get('limits', {}):
                    errors.append(f"Falta resources.limits.{k}")
        if 'livenessProbe' not in c:
            errors.append("El container debe definir livenessProbe")
        if 'readinessProbe' not in c:
            errors.append("El container debe definir readinessProbe")

# 2. Service ClusterIP puerto 80
svcs = kinds.get('Service', [])
if not svcs:
    errors.append("Falta un Service")
else:
    svc = svcs[0]
    stype = svc.get('spec', {}).get('type', 'ClusterIP')
    if stype != 'ClusterIP':
        errors.append(f"El Service debe ser type: ClusterIP (actual: {stype})")
    ports = svc.get('spec', {}).get('ports', [])
    if not ports or ports[0].get('port') != 80:
        errors.append("El Service debe exponer el puerto 80")

# 3. Ingress con host api.example.com
ings = kinds.get('Ingress', [])
if not ings:
    errors.append("Falta un Ingress")
else:
    ing = ings[0]
    if ing.get('apiVersion') != 'networking.k8s.io/v1':
        errors.append(f"Ingress: apiVersion debe ser 'networking.k8s.io/v1' (actual: {ing.get('apiVersion')})")
    rules = ing.get('spec', {}).get('rules', [])
    if not rules:
        errors.append("Ingress: falta spec.rules")
    else:
        if rules[0].get('host') != 'api.example.com':
            errors.append(f"Ingress: el host debe ser 'api.example.com' (actual: {rules[0].get('host')})")
        paths = rules[0].get('http', {}).get('paths', [])
        if not paths:
            errors.append("Ingress: falta paths en rules")
        else:
            backend = paths[0].get('backend', {})
            if backend.get('service', {}).get('name') != 'api':
                errors.append("Ingress: el backend.service.name debe ser 'api'")

# 4. HPA: min 2, max 10, CPU 70%
hpas = kinds.get('HorizontalPodAutoscaler', [])
if not hpas:
    errors.append("Falta un HorizontalPodAutoscaler")
else:
    hpa = hpas[0]
    if hpa.get('apiVersion') not in ('autoscaling/v2', 'autoscaling/v2beta2', 'autoscaling/v2beta1'):
        errors.append(f"HPA: apiVersion debe ser 'autoscaling/v2' (actual: {hpa.get('apiVersion')})")
    spec = hpa.get('spec', {})
    if spec.get('minReplicas') != 2:
        errors.append(f"HPA: minReplicas debe ser 2 (actual: {spec.get('minReplicas')})")
    if spec.get('maxReplicas') != 10:
        errors.append(f"HPA: maxReplicas debe ser 10 (actual: {spec.get('maxReplicas')})")
    metrics = spec.get('metrics', [])
    found_cpu = False
    for m in metrics:
        if m.get('type') == 'Resource' and m.get('resource', {}).get('name') == 'cpu':
            target = m.get('resource', {}).get('target', {})
            if target.get('averageUtilization') == 70:
                found_cpu = True
    if not found_cpu:
        errors.append("HPA: debe escalar por CPU al 70% (averageUtilization: 70)")

# 5. PDB: minAvailable 2
pdbs = kinds.get('PodDisruptionBudget', [])
if not pdbs:
    errors.append("Falta un PodDisruptionBudget")
else:
    pdb = pdbs[0]
    if pdb.get('apiVersion') != 'policy/v1':
        errors.append(f"PDB: apiVersion debe ser 'policy/v1' (actual: {pdb.get('apiVersion')})")
    if pdb.get('spec', {}).get('minAvailable') != 2:
        errors.append(f"PDB: minAvailable debe ser 2 (actual: {pdb.get('spec', {}).get('minAvailable')})")

# 6. ResourceQuota: CPU y memoria
rqs = kinds.get('ResourceQuota', [])
if not rqs:
    errors.append("Falta un ResourceQuota")
else:
    rq = rqs[0]
    hard = rq.get('spec', {}).get('hard', {})
    for k in ('requests.cpu', 'requests.memory', 'limits.cpu', 'limits.memory'):
        if k not in hard:
            errors.append(f"ResourceQuota: falta hard.{k}")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)
PYEOF

# Validación opcional con cluster
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster K8s detectado, aplicando y verificando..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
fi

echo "OK Tests pasaron"
exit 0
