# Ejercicio 26 - Deployment canary

- **Nivel:** 5/5
- **Tema:** Despliegues progresivos (canary) con dos Deployments
- **Tiempo estimado:** 30 min

## Enunciado

Un despliegue **canary** consiste en liberar una nueva versión a una pequeña parte del
tráfico para validarla antes de migrar todo. La forma más simple (sin service mesh) es
usar **dos Deployments** que comparten el mismo selector del Service pero con distinto
número de réplicas: el tráfico se reparte en proporción a las réplicas.

Crea:
- Un Deployment **stable** con la versión actual (ej. `nginx:1.25`) y **9 réplicas** (90%).
- Un Deployment **canary** con la nueva versión (ej. `nginx:1.27`) y **1 réplica** (10%).
- Ambos comparten el label `app: api` para que el mismo Service los seleccione.
- Un Service `api` que enruta tráfico a ambos deployments.

> Con 9+1=10 réplicas, el canary recibe ~10% del tráfico. Si falla, solo afecta a 1 de
> cada 10 peticiones.

## Requisitos

- [ ] Un Deployment `api-stable` con 9 réplicas y label `app: api`.
- [ ] Un Deployment `api-canary` con 1 réplica y label `app: api`.
- [ ] Un Service `api` que selecciona por `app: api`.
- [ ] La proporción de réplicas es 90/10 (9/1).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Ambos Deployments usan el mismo `spec.selector.matchLabels` (`app: api`) y el mismo
  `spec.template.metadata.labels` (`app: api`).
- El `metadata.name` de cada Deployment debe ser distinto (`api-stable`, `api-canary`).
- Para distinguirlos internamente, añade un label extra como `track: stable` y
  `track: canary`, pero el selector del Service usa solo `app: api`.
- El Service no sabe que hay dos Deployments: simplemente envía tráfico a todos los pods
  con `app: api`.
- El peso relativo es `réplicas_canary / (réplicas_stable + réplicas_canary)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment-stable.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-stable
  labels:
    app: api
    track: stable
spec:
  replicas: 9
  selector:
    matchLabels:
      app: api
      track: stable
  template:
    metadata:
      labels:
        app: api
        track: stable
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - containerPort: 80
```

`deployment-canary.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-canary
  labels:
    app: api
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
      track: canary
  template:
    metadata:
      labels:
        app: api
        track: canary
    spec:
      containers:
        - name: api
          image: nginx:1.27
          ports:
            - containerPort: 80
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 80
```

</details>
