# Ejercicio 29 — Rollback automático

- **Nivel:** 5/5
- **Tema:** health check, `kubectl rollout undo`, rollback automático tras fallo
- **Tiempo estimado:** 35 min

## Enunciado

Crea un workflow en `.github/workflows/rollback.yml` con despliegue + health check + rollback automático:

1. Job `deploy` (push a main): hace checkout, aplica el manifest de K8s con `kubectl apply -f k8s/`, hace `kubectl rollout status`, y luego ejecuta `scripts/health-check.sh` que hace curl a `/health`.
2. Si el health check falla, ejecuta `scripts/rollback.sh` que hace `kubectl rollout undo`.
3. Crea `scripts/health-check.sh` que hace 5 intentos de `curl -fsS http://mi-app-svc/health` con 5s de espera.
4. Crea `scripts/rollback.sh` que ejecuta `kubectl rollout undo deployment/mi-app`.
5. Crea `k8s/deployment.yaml` con un Deployment básico de nginx.

> El pipeline despliega, verifica, y si la app no responde, revierte automáticamente al estado anterior.

## Requisitos

- [ ] El archivo existe en `.github/workflows/rollback.yml`.
- [ ] El workflow aplica los manifests y hace `rollout status`.
- [ ] El workflow ejecuta `health-check.sh`.
- [ ] El workflow ejecuta `rollback.sh` si el health check falla (usa `if: failure()` o lógica en el script).
- [ ] Existe `scripts/health-check.sh` con shebang y `set -euo pipefail`.
- [ ] Existe `scripts/rollback.sh` con shebang y `set -euo pipefail`.
- [ ] Existe `k8s/deployment.yaml` con `kind: Deployment`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `kubectl rollout undo deployment/<name>` revierte al estado anterior del Deployment.
- `kubectl rollout status` espera a que el rollout termine (con `--timeout`).
- Para rollback automático, encadena con `if: failure()` en un job separado, o maneja el error dentro del script.
- `curl -fsS` falla con código non-zero si el HTTP no es 2xx.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
# scripts/health-check.sh
set -euo pipefail
for i in $(seq 1 5); do
    if curl -fsS http://mi-app-svc/health; then
        echo "Health OK"
        exit 0
    fi
    echo "Intento $i fallido, reintentando en 5s..."
    sleep 5
done
echo "Health check falló después de 5 intentos"
exit 1
```

```bash
#!/usr/bin/env bash
# scripts/rollback.sh
set -euo pipefail
echo "Ejecutando rollback..."
kubectl rollout undo deployment/mi-app
kubectl rollout status deployment/mi-app --timeout=2m
echo "Rollback completado"
```

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-app
  labels:
    app: mi-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: mi-app
  template:
    metadata:
      labels:
        app: mi-app
    spec:
      containers:
        - name: app
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
```

```yaml
# .github/workflows/rollback.yml
name: Deploy con Rollback
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Aplicar manifest
        run: kubectl apply -f k8s/
      - name: Esperar rollout
        run: kubectl rollout status deployment/mi-app --timeout=2m
      - name: Health check
        run: bash scripts/health-check.sh
  rollback:
    needs: deploy
    if: failure()
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Rollback automático
        run: bash scripts/rollback.sh
```

</details>
