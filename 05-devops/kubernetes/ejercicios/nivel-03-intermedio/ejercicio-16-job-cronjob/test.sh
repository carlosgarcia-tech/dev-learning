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

# Debe existir un Job db-migration
if 'Job' not in kinds:
    print("Falta el recurso Job")
    sys.exit(1)
job = kinds['Job']
if job['metadata'].get('name') != 'db-migration':
    print(f"Job: el nombre debe ser 'db-migration' (es '{job['metadata'].get('name')}')")
    sys.exit(1)
jspec = job.get('spec', {})
if jspec.get('completions') != 1:
    print(f"Job: completions debe ser 1 (es {jspec.get('completions')})")
    sys.exit(1)
if jspec.get('parallelism') != 1:
    print(f"Job: parallelism debe ser 1 (es {jspec.get('parallelism')})")
    sys.exit(1)
if jspec.get('backoffLimit') != 3:
    print(f"Job: backoffLimit debe ser 3 (es {jspec.get('backoffLimit')})")
    sys.exit(1)
jpodspec = jspec.get('template', {}).get('spec', {})
if jpodspec.get('restartPolicy') != 'OnFailure':
    print(f"Job: restartPolicy debe ser 'OnFailure' (es '{jpodspec.get('restartPolicy')}')")
    sys.exit(1)
jcontainers = jpodspec.get('containers', [])
if not jcontainers:
    print("Job: falta definir containers")
    sys.exit(1)
jc0 = jcontainers[0]
if jc0.get('image') != 'busybox:1.36':
    print(f"Job: la imagen debe ser 'busybox:1.36' (es '{jc0.get('image')}')")
    sys.exit(1)
if 'command' not in jc0:
    print("Job: el contenedor debe definir 'command'")
    sys.exit(1)

# Debe existir un CronJob backup-db
if 'CronJob' not in kinds:
    print("Falta el recurso CronJob")
    sys.exit(1)
cj = kinds['CronJob']
if cj['metadata'].get('name') != 'backup-db':
    print(f"CronJob: el nombre debe ser 'backup-db' (es '{cj['metadata'].get('name')}')")
    sys.exit(1)
cspec = cj.get('spec', {})
if cspec.get('schedule') != '0 2 * * *':
    print(f"CronJob: schedule debe ser '0 2 * * *' (es '{cspec.get('schedule')}')")
    sys.exit(1)
cjpodspec = cspec.get('jobTemplate', {}).get('spec', {}).get('template', {}).get('spec', {})
if cjpodspec.get('restartPolicy') != 'OnFailure':
    print(f"CronJob: restartPolicy debe ser 'OnFailure' (es '{cjpodspec.get('restartPolicy')}')")
    sys.exit(1)
ccontainers = cjpodspec.get('containers', [])
if not ccontainers:
    print("CronJob: falta definir containers")
    sys.exit(1)
cc0 = ccontainers[0]
if cc0.get('image') != 'busybox:1.36':
    print(f"CronJob: la imagen debe ser 'busybox:1.36' (es '{cc0.get('image')}')")
    sys.exit(1)
if 'command' not in cc0:
    print("CronJob: el contenedor debe definir 'command'")
    sys.exit(1)

print("OK Validación específica Job y CronJob")
PYEOF

# Si hay cluster, aplicar y verificar
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster detectado. Aplicando manifiestos..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  sleep 3
  kubectl get job db-migration >/dev/null 2>&1 || fail "No se encontró el Job db-migration"
  kubectl get cronjob backup-db >/dev/null 2>&1 || fail "No se encontró el CronJob backup-db"
  kubectl delete -f "$YAML_DIR" --ignore-not-found >/dev/null 2>&1 || true
  echo "Validación en cluster OK."
fi

echo "OK Tests pasaron"
exit 0
