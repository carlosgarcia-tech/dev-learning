# Ejercicio 06 - Labels y Selectors

- **Nivel:** 1/5
- **Tema:** Labels, selectors y Services
- **Tiempo estimado:** 25 min

## Enunciado

Crea un manifiesto YAML (uno o varios documentos) que defina:

1. Un **Deployment** llamado `web-deploy`:
   - Imagen `nginx:alpine`, 2 réplicas, puerto `80`.
   - El Pod template debe tener las labels `app: web` y `tier: frontend`.
   - El selector del Deployment (`matchLabels`) debe seleccionar esas mismas labels.

2. Un **Service** de tipo `ClusterIP` llamado `web-service`:
   - Debe **seleccionar** los Pods con label `app: web`.
   - Puerto del Service: `80` (`port: 80`).
   - Puerto del contenedor destino: `80` (`targetPort: 80`).

El objetivo es entender cómo las **labels** permiten organizar recursos y cómo los **Services** usan **selectors** para descubrir y balancear tráfico hacia un conjunto de Pods.

## Requisitos

- [ ] Existe un archivo `*.yaml` en la raíz del ejercicio.
- [ ] El manifiesto define un Deployment `web-deploy` con 2 réplicas.
- [ ] El Pod template del Deployment tiene las labels `app: web` y `tier: frontend`.
- [ ] El selector del Deployment coincide con las labels del template.
- [ ] El manifiesto define un Service `web-service` de tipo `ClusterIP`.
- [ ] El Service selecciona Pods con label `app: web`.
- [ ] El Service expone `port: 80` y `targetPort: 80`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las **labels** son pares clave-valor que se asignan a los recursos en `metadata.labels`.
- Los **selectors** permiten filtrar recursos por sus labels.
- Un **Deployment** usa `spec.selector.matchLabels` para identificar qué Pods gestiona.
- Un **Service** usa `spec.selector` (directamente un mapa) para elegir a qué Pods enviar tráfico.
- El Service enruta tráfico desde `port` hacia el `targetPort` de los Pods seleccionados.

Estructura:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
      tier: frontend
  template:
    metadata:
      labels:
        app: web
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `labels-selectors.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
      tier: frontend
  template:
    metadata:
      labels:
        app: web
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```

**Explicación:**

- El Deployment crea Pods con labels `app: web` y `tier: frontend`.
- Su `selector.matchLabels` **debe coincidir** con las labels del template, si no Kubernetes rechaza el manifiesto.
- El Service `web-service` tiene un `selector` que filtra Pods por `app: web`. Kubernetes crea automáticamente **endpoints** para todos los Pods que cumplan esa condición.
- El tráfico que llega al Service por el `port: 80` se reenvía al `targetPort: 80` de los Pods seleccionados.
- Al ser `type: ClusterIP`, el Service recibe una IP interna accesible solo desde dentro del cluster.

Para aplicarlo en un cluster real:

```bash
kubectl apply -f labels-selectors.yaml
kubectl get deploy,pods,svc -l app=web
kubectl describe svc web-service
# Probar el Service desde dentro del cluster:
kubectl run tmp --rm -it --image=busybox -- curl -s http://web-service
```

</details>
