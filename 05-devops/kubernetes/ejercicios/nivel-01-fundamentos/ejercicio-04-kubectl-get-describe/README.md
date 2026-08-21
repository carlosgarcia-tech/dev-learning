# Ejercicio 04 - Practicar kubectl get y describe

- **Nivel:** 1/5
- **Tema:** Inspección de recursos con `kubectl get` y `kubectl describe`
- **Tiempo estimado:** 20 min

## Enunciado

Este ejercicio es **práctico**: consiste en familiarizarte con los comandos de inspección de Kubernetes
`kubectl get` y `kubectl describe`. Para ello se proporcionan dos manifiestos (un Deployment y un Pod)
que debes aplicar en un cluster y luego inspeccionar.

Tareas a realizar (con un cluster kind/minikube disponible):

1. Aplica los manifiestos del ejercicio:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f pod.yaml
   ```
2. Lista los recursos con `kubectl get`:
   ```bash
   kubectl get pods
   kubectl get deploy
   kubectl get pods -o wide
   kubectl get pods --show-labels
   ```
3. Obtén detalles con `kubectl describe`:
   ```bash
   kubectl describe deploy app-deploy
   kubectl describe pod app-pod
   ```
4. Responde (en tu mente o en una hoja):
   - ¿Qué información muestra `get` frente a `describe`?
   - ¿En qué sección de `describe` apareman los eventos del recurso?
   - ¿Qué nodo (node) se asignó a cada Pod?

> **Nota:** Sin un cluster, el `test.sh` valida únicamente que los manifiestos YAML sean correctos.

## Requisitos

- [ ] Existen los archivos `deployment.yaml` y `pod.yaml` en la raíz del ejercicio.
- [ ] `deployment.yaml` define un Deployment llamado `app-deploy` con 2 réplicas.
- [ ] `pod.yaml` define un Pod llamado `app-pod`.
- [ ] Practicaste los comandos `kubectl get` y `kubectl describe` sobre los recursos.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `kubectl get <recurso>` lista recursos de forma resumida (tabla).
- `kubectl get <recurso> -o wide` añade columnas extra (nodo, IP, etc.).
- `kubectl get <recurso> --show-labels` muestra las labels de cada recurso.
- `kubectl describe <recurso> <nombre>` muestra información detallada: spec, estado, eventos, etc.
- Puedes listar todos los recursos de un namespace con `-n <namespace>` o `--all-namespaces`.
- `kubectl get all` muestra los recursos más comunes del namespace actual.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

### `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deploy
  labels:
    app: app
spec:
  replicas: 2
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
          image: nginx:alpine
          ports:
            - containerPort: 80
```

### `pod.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
  labels:
    app: app
spec:
  containers:
    - name: app
      image: nginx:alpine
      ports:
        - containerPort: 80
```

### Comandos de inspección

```bash
# Aplicar
kubectl apply -f deployment.yaml
kubectl apply -f pod.yaml

# get (resumen)
kubectl get pods
kubectl get deploy
kubectl get pods -o wide
kubectl get pods --show-labels

# describe (detalle)
kubectl describe deploy app-deploy
kubectl describe pod app-pod

# Ver eventos de un Pod (útil para depurar)
kubectl get events --sort-by='.lastTimestamp'
```

**Diferencia `get` vs `describe`:**

| Comando  | Muestra |
|----------|---------|
| `get`    | Vista tabular y resumida (nombre, estado, edad, reinicios) |
| `describe`| Información completa: spec, status, condiciones, eventos recientes |

Los **eventos** del recurso aparecen al final de la salida de `describe`, en la sección `Events:`.

</details>
