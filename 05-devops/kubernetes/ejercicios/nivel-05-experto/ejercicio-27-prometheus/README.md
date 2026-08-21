# Ejercicio 27 - Monitorización con Prometheus

- **Nivel:** 5/5
- **Tema:** Monitorización: ServiceMonitor y métricas en /metrics
- **Tiempo estimado:** 35 min

## Enunciado

[Prometheus](https://prometheus.io/) es el estándar de facto para monitorización en
Kubernetes. El operador de Prometheus (Prometheus Operator) usa un CRD llamado
**ServiceMonitor** para descubrir automáticamente los Services que exponen métricas y
scrapearlos.

Crea:
- Un Deployment con un contenedor que expone métricas en el path `/metrics` y puerto
  `8080` (puedes usar la imagen `prom/prometheus` o cualquier app instrumentada).
- Un Service que seleccione los pods del Deployment y exponga el puerto `8080`.
- Un **ServiceMonitor** (CRD de Prometheus Operator) que indique a Prometheus que scrapee
  el Service en el path `/metrics` cada 15s.

> El ServiceMonitor es el puente entre tu app y Prometheus: define qué Service scrapear,
> con qué intervalo y en qué path.

## Requisitos

- [ ] Un Deployment con un contenedor que expone el puerto 8080.
- [ ] Un Service tipo ClusterIP que expone el puerto 8080.
- [ ] Un ServiceMonitor con `apiVersion: monitoring.coreos.com/v1`.
- [ ] El ServiceMonitor referencia el Service por `selector.matchLabels`.
- [ ] El ServiceMonitor define `endpoints[].path: /metrics` e `interval: 15s`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` del ServiceMonitor es `monitoring.coreos.com/v1` y `kind: ServiceMonitor`.
- El ServiceMonitor tiene `spec.selector.matchLabels` que debe coincidir con los labels
  del Service (no del Deployment).
- En `spec.endpoints` defines `port` (nombre del port del Service), `path` (`/metrics`) e
  `interval` (`15s`).
- El Service debe tener un `name` en el puerto (ej. `metrics`) para que el ServiceMonitor
  pueda referenciarlo por nombre.
- Usa una imagen que exponga /metrics, como `prom/prometheus` o `nginx` con un exporter.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: metrics-app
  labels:
    app: metrics-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: metrics-app
  template:
    metadata:
      labels:
        app: metrics-app
    spec:
      containers:
        - name: metrics-app
          image: prom/prometheus:v2.50.0
          ports:
            - name: metrics
              containerPort: 9090
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: metrics-app
  labels:
    app: metrics-app
spec:
  selector:
    app: metrics-app
  ports:
    - name: metrics
      port: 8080
      targetPort: 9090
```

`servicemonitor.yaml`:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: metrics-app
  labels:
    app: metrics-app
spec:
  selector:
    matchLabels:
      app: metrics-app
  endpoints:
    - port: metrics
      path: /metrics
      interval: 15s
```

</details>
