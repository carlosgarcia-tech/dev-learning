# Ejercicio 26 — Canary deployment

- **Nivel:** 5/5
- **Tema:** canary, Argo Rollouts, `Rollout`, `setWeight`, métricas
- **Tiempo estimado:** 40 min

## Enunciado

Crea un despliegue canary con Argo Rollouts. Necesitas:

1. `k8s/rollout.yaml` — un recurso `Rollout` (API `argoproj.io/v1alpha1`) que:
   - Tenga 10 réplicas.
   - Use `strategy: canary`.
   - Tenga steps: 10% → pausa 2m → 30% → pausa 2m → 100%.
   - Referencie el Service `mi-app-svc`.
2. `k8s/service.yaml` — un Service `mi-app-svc` tipo `ClusterIP` con selector `app: mi-app`.
3. `.github/workflows/canary.yml` — workflow que aplica los manifests y describe el rollout.

> Argo Rollouts gestiona la progresión canary: envía el 10% del tráfico, espera, sube a 30%, espera, y si todo va bien, completa el rollout al 100%.

## Requisitos

- [ ] Existe `k8s/rollout.yaml` con `kind: Rollout` y `apiVersion: argoproj.io/v1alpha1`.
- [ ] El Rollout tiene `strategy: canary` con `steps`.
- [ ] Los steps incluyen `setWeight` (10 y 30 mínimo) y `pause`.
- [ ] Existe `k8s/service.yaml` con `kind: Service`.
- [ ] El workflow aplica los manifests.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Argo Rollouts usa el CRD `Rollout` (no `Deployment`) para gestionar estrategias avanzadas.
- `setWeight: 10` envía el 10% del tráfico al canary; `pause` detiene la progresión.
- El Service estable coincide para estable y canary; Rollouts gestiona el tráfico interno.
- Necesitas Argo Rollouts instalado en el clúster para que funcione.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# k8s/rollout.yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: mi-app
spec:
  replicas: 10
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
  strategy:
    canary:
      canaryService: mi-app-canary
      stableService: mi-app-stable
      steps:
        - setWeight: 10
        - pause: { duration: 2m }
        - setWeight: 30
        - pause: { duration: 2m }
        - setWeight: 100
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
  ports:
    - port: 80
      targetPort: 80
```

```yaml
# .github/workflows/canary.yml
name: Canary
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
      - name: Estado del rollout
        run: kubectl argo rollouts get rollout mi-app --watch --timeout 5m
```

</details>
