# Ejercicio 24 - Deployment con estrategia RollingUpdate

- **Nivel:** 4/5
- **Tema:** Estrategias de actualización de Deployments
- **Tiempo estimado:** 25 min

## Enunciado

Crea un **Deployment** que use la estrategia **RollingUpdate** con `maxSurge` y
`maxUnavailable` definidos para controlar cómo se actualizan los pods durante un
despliegue.

El Deployment debe:
- Tener 4 réplicas.
- Usar `strategy.type: RollingUpdate`.
- Definir `maxSurge` (por ejemplo `1` o `25%`) y `maxUnavailable` (por ejemplo `0` o
  `25%`).

> La estrategia `RollingUpdate` actualiza los pods de forma progresiva, manteniendo
> disponibilidad. `maxSurge` indica cuántos pods extra pueden crearse por encima del
> número de réplicas, y `maxUnavailable` cuántos pods pueden estar no disponibles
> durante el despliegue.

## Requisitos

- [ ] Un Deployment con 4 réplicas.
- [ ] `strategy.type: RollingUpdate`.
- [ ] `strategy.rollingUpdate.maxSurge` definido.
- [ ] `strategy.rollingUpdate.maxUnavailable` definido.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `spec.strategy.type` puede ser `RollingUpdate` o `Recreate`.
- `maxSurge` y `maxUnavailable` admiten un entero (`1`) o un porcentaje (`25%`).
- Con `maxUnavailable: 0` y `maxSurge: 1` siempre hay 4 pods disponibles durante la
  actualización (cero downtime).
- La estrategia se define a nivel de `spec.strategy` del Deployment.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  labels:
    app: app
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: nginx:1.25
          ports:
            - containerPort: 80
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app
spec:
  selector:
    app: app
  ports:
    - port: 80
      targetPort: 80
```

</details>
