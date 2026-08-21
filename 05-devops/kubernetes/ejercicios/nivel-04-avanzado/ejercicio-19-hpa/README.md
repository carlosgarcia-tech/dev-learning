# Ejercicio 19 - Horizontal Pod Autoscaler (HPA)

- **Nivel:** 4/5
- **Tema:** Autoescalado horizontal de pods basado en métricas de CPU
- **Tiempo estimado:** 30 min

## Enunciado

Crea un **Deployment** exponiendo una web con `nginx`, un **Service** ClusterIP y un
**HorizontalPodAutoscaler** (HPA) que escale automáticamente el número de réplicas en
función del consumo de CPU.

El HPA debe:
- Apuntar al Deployment creado.
- Mantener entre 2 y 10 réplicas (`minReplicas`/`maxReplicas`).
- Escalar cuando la utilización media de CPU supere el 50 %.

> **Importante:** para que el HPA pueda calcular la utilización de CPU, los contenedores
> del Deployment **deben** definir `resources.requests.cpu`.

## Requisitos

- [ ] Un Deployment `web` con `resources.requests.cpu` definido.
- [ ] Un Service ClusterIP `web`.
- [ ] Un HorizontalPodAutoscaler `web` que escale por CPU (umbral 50 %).
- [ ] El HPA referencia correctamente al Deployment (`scaleTargetRef`).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` del HPA moderno es `autoscaling/v2`.
- `scaleTargetRef` necesita `apiVersion`, `kind` y `name` del recurso a escalar.
- Sin `resources.requests.cpu` en el contenedor, el HPA de CPU no tiene forma de
  calcular el porcentaje de uso y no escalará.
- La métrica se define en `spec.metrics[].resource.target.averageUtilization`.
- Para probar el escalado real necesitas el Metrics Server instalado en el cluster.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 200m
              memory: 256Mi
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```

`hpa.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

</details>
