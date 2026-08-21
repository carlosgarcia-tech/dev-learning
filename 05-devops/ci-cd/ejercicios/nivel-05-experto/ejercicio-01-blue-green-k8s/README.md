# Ejercicio 25 — Blue-green deploy con K8s

- **Nivel:** 5/5
- **Tema:** blue-green, Kubernetes, Service selector, deployment, conmutación
- **Tiempo estimado:** 40 min

## Enunciado

Crea un despliegue blue-green con Kubernetes. Necesitas:

1. `k8s/blue-deployment.yaml` — un Deployment `mi-app-blue` con label `version: blue`, 2 réplicas, imagen `nginx:1.25-alpine`.
2. `k8s/green-deployment.yaml` — un Deployment `mi-app-green` con label `version: green`, 2 réplicas, misma imagen.
3. `k8s/service.yaml` — un Service `mi-app-svc` tipo `ClusterIP` cuyo `selector` apunta a `version: blue` (la versión activa).
4. `.github/workflows/blue-green.yml` — un workflow que:
   - Se dispara en `push` a `main`.
   - Aplica los manifests con `kubectl apply -f k8s/`.
   - Espera a que el rollout de green termine (`kubectl rollout status deployment/mi-app-green`).
   - Conmuta el Service a green (`kubectl patch svc mi-app-svc ...`).
   - Hace un health check (`curl`).
   - Si falla, revierte el Service a blue.

## Requisitos

- [ ] Existe `k8s/blue-deployment.yaml` con `kind: Deployment` y label `version: blue`.
- [ ] Existe `k8s/green-deployment.yaml` con `kind: Deployment` y label `version: green`.
- [ ] Existe `k8s/service.yaml` con `kind: Service` y `selector` con `version: blue`.
- [ ] El workflow aplica los manifests y conmuta el Service.
- [ ] El workflow tiene un health check y lógica de rollback.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Blue-green: dos Deployments idénticos con distinto label de versión. El Service dirige el tráfico al que tenga su selector.
- Para conmutar, cambias el `selector` del Service de `version: blue` a `version: green`.
- `kubectl patch svc <name> -p '{"spec":{"selector":{"version":"green"}}}'` cambia el selector al vuelo.
- El rollback es revertir el selector a `blue`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# k8s/blue-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-app-blue
  labels:
    app: mi-app
    version: blue
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mi-app
      version: blue
  template:
    metadata:
      labels:
        app: mi-app
        version: blue
    spec:
      containers:
        - name: app
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
```

```yaml
# k8s/green-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-app-green
  labels:
    app: mi-app
    version: green
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mi-app
      version: green
  template:
    metadata:
      labels:
        app: mi-app
        version: green
    spec:
      containers:
        - name: app
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
```

```yaml
# k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mi-app-svc
spec:
  type: ClusterIP
  selector:
    app: mi-app
    version: blue
  ports:
    - port: 80
      targetPort: 80
```

```yaml
# .github/workflows/blue-green.yml
name: Blue-Green
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Aplicar manifests
        run: kubectl apply -f k8s/
      - name: Esperar rollout de green
        run: kubectl rollout status deployment/mi-app-green --timeout=2m
      - name: Conmutar a green
        run: |
          kubectl patch svc mi-app-svc -p '{"spec":{"selector":{"version":"green"}}}'
      - name: Health check
        run: |
          for i in $(seq 1 5); do
            if curl -fsS http://mi-app-svc/; then exit 0; fi
            sleep 3
          done
          echo "Health check falló, revirtiendo a blue"
          kubectl patch svc mi-app-svc -p '{"spec":{"selector":{"version":"blue"}}}'
          exit 1
```

</details>
