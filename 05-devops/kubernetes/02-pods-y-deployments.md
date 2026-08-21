# 02 — Pods y Deployments

## Objetivos

- [ ] Entender el Pod en profundidad: por qué agrupa contenedores y qué comparten.
- [ ] Definir Pods en YAML con contenedores, puertos, variables de entorno y recursos.
- [ ] Crear **multi-container pods** (sidecar, ambassador, adapter).
- [ ] Comprender y crear **Deployments** que gestionan pods de forma declarativa.
- [ ] Entender los **ReplicaSets** y su relación con los Deployments.
- [ ] Usar **labels y selectors** para organizar y seleccionar recursos.
- [ ] Añadir **anotaciones** para metadatos de herramientaing.
- [ ] Aplicar **estrategias de actualización**: `RollingUpdate` y `Recreate`.
- [ ] Escalar deployments manualmente con `kubectl scale`.
- [ ] Gestionar historial de actualizaciones: `kubectl rollout history`, `status` y `undo`.

## Apuntes

### El Pod en profundidad

Un **Pod** es la unidad de ejecución más pequeña de Kubernetes. Agrupa uno o varios contenedores que:

- Comparten la misma **dirección de red** (misma IP, mismos puertos).
- Comparten el mismo **hostname**.
- Pueden compartir **volúmenes** de almacenamiento.
- Se programan en el mismo **nodo**.
- Se crean, escalan y destruyen **juntos**.

Los contenedores de un mismo pod pueden hablar entre sí vía `localhost` (comparten red). Esto permite patrones como el *sidecar*.

> Un pod es efímero: cuando muere, no "resucita". Se crea otro nuevo con otra IP. Por eso **nunca se crean pods directamente en producción**; se usan controllers (Deployment, StatefulSet, Job) que gestionan los pods.

#### Definir un Pod en YAML

```yaml
# pod-basico.yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  labels:
    app: web
    tier: frontend
spec:
  containers:
    - name: nginx
      image: nginx:1.25
      ports:
        - containerPort: 80
          name: http
      env:
        - name: ENTORNO
          value: "produccion"
        - name: LOG_LEVEL
          value: "debug"
      resources:
        requests:
          cpu: "100m"
          memory: "128Mi"
        limits:
          cpu: "250m"
          memory: "256Mi"
  restartPolicy: Always
```

| Campo | Descripción |
|---|---|
| `spec.containers[].name` | Nombre del contenedor (único en el pod) |
| `spec.containers[].image` | Imagen del contenedor |
| `spec.containers[].ports` | Puertos que expone |
| `spec.containers[].env` | Variables de entorno |
| `spec.containers[].resources` | Requests y limits de CPU/memoria |
| `spec.restartPolicy` | `Always` (pods), `OnFailure`, `Never` (Jobs) |

### Multi-container pods

Un pod puede tener varios contenedores. Los patrones más comunes son:

| Patrón | Descripción | Ejemplo |
|---|---|---|
| **Sidecar** | Un contenedor secundario que ayuda al principal | Contenedor de logging junto al de la app |
| **Ambassador** | Un proxy que adapta conexiones externas | Proxy que traduce a un servicio legacy |
| **Adapter** | Normaliza la salida (logs, métricas) del contenedor principal | Adaptador de métricas Prometheus |

```yaml
# pod-multi-container.yaml — patrón sidecar
apiVersion: v1
kind: Pod
metadata:
  name: app-con-sidecar
  labels:
    app: mi-app
spec:
  containers:
    - name: app
      image: nginx:1.25
      ports:
        - containerPort: 80
      volumeMounts:
        - name: logs-compartidos
          mountPath: /var/log/nginx
    - name: logger              # sidecar que lee los logs de nginx
      image: busybox:1.36
      command: ["sh", "-c", "tail -f /var/log/nginx/access.log"]
      volumeMounts:
        - name: logs-compartidos
          mountPath: /var/log/nginx
  volumes:
    - name: logs-compartidos
      emptyDir: {}
```

Ambos contenedores montan el mismo volumen `emptyDir` y comparten los ficheros de log. El contenedor `app` escribe logs; el `logger` los lee y los envía (en este ejemplo solo hace `tail -f`).

### Deployments

Un **Deployment** es un controller que gestiona un conjunto de pods idénticos (réplicas). Garantiza que siempre haya el número deseado de réplicas corriendo y permite actualizaciones declarativas sin downtime.

Un Deployment crea un **ReplicaSet**, y el ReplicaSet crea los **Pods**. La cadena es:

```
Deployment → ReplicaSet → Pods
```

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3                      # número de pods deseados
  selector:
    matchLabels:
      app: nginx                   # el deployment gestiona los pods con esta label
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1                  # cuántos pods extra puede crear durante el update
      maxUnavailable: 0             # cuántos pods pueden estar no disponibles durante el update
  template:                         # plantilla del pod
    metadata:
      labels:
        app: nginx                 # debe coincidir con el selector
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "200m"
              memory: "256Mi"
```

> La parte más importante: el `selector.matchLabels` del Deployment **debe coincidir** con las `labels` de la plantilla del pod (`template.metadata.labels`). Si no coinciden, K8s se queja al aplicar.

#### ¿Por qué usar Deployments y no Pods directos?

| Pod directo | Deployment |
|---|---|
| Si muere, no se recrea | Si un pod muere, se crea otro automáticamente |
| No escalable | `replicas: N` crea N pods |
| Sin actualizaciones sin downtime | Rolling updates automáticos |
| Sin rollback | `kubectl rollout undo` |
| No gestionado | Auto-gestionado por el controller |

### ReplicaSets

Un **ReplicaSet** garantiza que haya un número determinado de réplicas de un pod corriendo. Normalmente **no se crean ReplicaSets directamente**: los crea el Deployment. Pero conviene conocerlos.

```yaml
# replicaset.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
```

Un Deployment crea un ReplicaSet nuevo cada vez que cambia la plantilla del pod (p. ej. al cambiar la imagen). Así puede mantener el histórico para hacer rollbacks.

```bash
kubectl get replicasets
# NAME                       DESIRED   CURRENT   READY   AGE
# nginx-deployment-6b474476c4   3         3         3       5m
# nginx-deployment-7c4b4476c4   0         0         0       10m   ← anterior, escala a 0
```

### Labels y selectors

Las **labels** son pares clave-valor que se asignan a los recursos (pods, services, deployments...). Sirven para **identificar, agrupar y seleccionar** recursos.

```yaml
metadata:
  labels:
    app: mi-app
    version: "1.0"
    tier: frontend
    environment: produccion
```

Los **selectors** permiten seleccionar recursos por sus labels. Hay dos tipos:

#### `matchLabels` (igualdad exacta)

```yaml
selector:
  matchLabels:
    app: nginx
    version: "1.0"
```

#### `matchExpressions` (operadores)

```yaml
selector:
  matchExpressions:
    - { key: app, operator: In, values: [nginx, apache] }
    - { key: tier, operator: NotIn, values: [backend] }
    - { key: environment, operator: Exists }
```

| Operador | Significado |
|---|---|
| `In` | El valor de la label está en la lista |
| `NotIn` | El valor no está en la lista |
| `Exists` | La label existe (sin importar el valor) |
| `DoesNotExist` | La label no existe |

```bash
# Listar pods por label
kubectl get pods -l app=nginx
kubectl get pods -l 'tier in (frontend, backend)'
kubectl get pods -l environment=produccion,version=1.0
kubectl get pods --show-labels
kubectl label pod nginx-pod team=devops       # añadir una label
kubectl label pod nginx-pod team-              # borrar una label (con guion final)
```

### Anotaciones

Las **anotaciones** (annotations) son, como las labels, pares clave-valor, pero se usan para **metadatos no identificativos**: información para herramientas (Helm, kubectl, Prometheus, etc.). No se pueden usar para seleccionar recursos.

```yaml
metadata:
  annotations:
    kubernetes.io/change-cause: "Actualización a nginx 1.25"
    deployment.kubernetes.io/revision: "3"
    helm.sh/hook: pre-install
    description: "Frontend de la tienda online"
```

| | Labels | Annotations |
|---|---|---|
| **Propósito** | Identificar y seleccionar | Metadatos para herramientas |
| **Seleccionables** | Sí (`selector`) | No |
| **Tamaño** | Cortas (≤63 chars) | Pueden ser largas |
| **Ejemplos** | `app`, `version`, `tier` | `change-cause`, `helm.sh/hook` |

### Estrategias de actualización

El campo `spec.strategy` de un Deployment define cómo se actualizan los pods cuando cambias algo (p. ej. la imagen).

#### RollingUpdate (por defecto)

Crea pods nuevos antes de borrar los viejos, asegurando cero downtime si `maxUnavailable: 0`.

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1            # 1 pod extra máximo durante la actualización
    maxUnavailable: 0      # 0 pods no disponibles: siempre hay réplicas activas
```

#### Recreate

Borra todos los pods viejos antes de crear los nuevos. Hay downtime, pero es útil cuando la app no soporta versiones concurrentes (p. ej. migraciones de DB).

```yaml
strategy:
  type: Recreate
```

### Escalado manual

Puedes cambiar el número de réplicas de un Deployment sin tocar el YAML:

```bash
# Escalar a 5 réplicas
kubectl scale deployment nginx-deployment --replicas=5

# Escalar a 0 (pausar la app sin borrarla)
kubectl scale deployment nginx-deployment --replicas=0

# Ver el resultado
kubectl get deployment nginx-deployment
# NAME               READY   UP-TO-DATE   AVAILABLE   AGE
# nginx-deployment   5/5     5            5           10m
```

También puedes editar el YAML y hacer `kubectl apply -f deployment.yaml` con `replicas: 5`.

> El escalado manual es útil para pruebas, pero en producción se usa **HPA** (Horizontal Pod Autoscaler) para escalar según la carga (ver guía 04).

### Rollouts: history, status y undo

Cuando actualizas un Deployment (cambias la imagen, variables, etc.), K8s guarda el historial de revisiones. Puedes ver el estado y hacer rollback.

```bash
# Actualizar la imagen (dispara un nuevo rollout)
kubectl set image deployment/nginx-deployment nginx=nginx:1.26

# Ver el estado del rollout
kubectl rollout status deployment/nginx-deployment
# deployment "nginx-deployment" successfully rolled out

# Ver el historial de revisiones
kubectl rollout history deployment/nginx-deployment
# REVISION  CHANGE-CAUSE
# 1         <none>
# 2         <none>

# Ver detalles de una revisión concreta
kubectl rollout history deployment/nginx-deployment --revision=2

# Hacer rollback a la revisión anterior
kubectl rollout undo deployment/nginx-deployment

# Hacer rollback a una revisión concreta
kubectl rollout undo deployment/nginx-deployment --to-revision=1

# Pausar un rollout (útil para canary)
kubectl rollout pause deployment/nginx-deployment

# Reanudar un rollout pausado
kubectl rollout resume deployment/nginx-deployment
```

Para que el `CHANGE-CAUSE` del historial tenga sentido, añade la anotación al actualizar:

```bash
kubectl annotate deployment/nginx-deployment kubernetes.io/change-cause="Actualización a nginx 1.26" --record=false
```

### Ejemplo completo: deployment con rollout

```yaml
# deployment-v1.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
  labels:
    app: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: api
        version: "1.0"
    spec:
      containers:
        - name: api
          image: hashicorp/http-echo:1.0
          args:
            - "-listen=:8080"
            - "-text=v1"
          ports:
            - containerPort: 8080
```

```bash
# Desplegar v1
kubectl apply -f deployment-v1.yaml

# Actualizar a v2 cambiando el texto
kubectl set image deployment/api-deployment api=hashicorp/http-echo:1.0
kubectl edit deployment api-deployment   # cambiar args a "-text=v2"

# Ver el rollout en curso
kubectl rollout status deployment/api-deployment

# Si algo va mal, deshacer
kubectl rollout undo deployment/api-deployment
```

### Conceptos clave

| Concepto | Definición |
|---|---|
| **Deployment** | Controller que gestiona pods con réplicas, rolling updates y rollbacks |
| **ReplicaSet** | Controller que garantiza un número de réplicas; lo crea el Deployment |
| **Pod** | Unidad mínima; agrupa contenedores que comparten red y almacenamiento |
| **Label** | Par clave-valor para identificar y seleccionar recursos |
| **Selector** | Expresión que selecciona recursos por sus labels |
| **Annotation** | Metadatos no identificativos (para herramientas) |
| **Replica** | Cada una de las copias idénticas de un pod |
| **RollingUpdate** | Estrategia que actualiza sin downtime creando pods nuevos antes de borrar viejos |
| **Recreate** | Estrategia que borra todos los pods antes de crear los nuevos (downtime) |
| **Rollout** | El proceso de una actualización de un Deployment |
| **Sidecar** | Contenedor secundario que asiste al principal en el mismo pod |

## Errores comunes

- **Selector que no coincide con las labels del template** → error al aplicar: `the deployment "X" is invalid: spec.template.metadata.labels: Invalid value`. Asegúrate de que `selector.matchLabels` coincide exactamente con `template.metadata.labels`.

  ```yaml
  # ❌ selector dice "app: web" pero el template dice "app: nginx"
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: nginx

  # ✅ coinciden
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
  ```

- **Cambiar las labels del template en un Deployment existente** → el Deployment no puede cambiar su selector una vez creado. Si necesitas cambiar labels, borra y recrea el Deployment.

- **Olvidar `replicas`** → por defecto es 1. Si querías 3, la app no escala. Define `replicas: 3` explícitamente.

- **Usar `kubectl create` para actualizar** → `create` falla si el recurso ya existe. Usa `kubectl apply -f` para crear y actualizar.

- **Pensar que `kubectl scale` modifica tu YAML** → `scale` cambia el estado en el cluster, pero tu fichero YAML sigue diciendo lo mismo. La próxima vez que hagas `apply`, volverá al valor del YAML. Edita el YAML o usa `apply` con cuidado.

- **`maxUnavailable: 0` con `replicas: 1`** → durante un rolling update, con 1 réplica y `maxUnavailable: 0`, K8s no puede actualizar sin crear antes la nueva. Funciona, pero es más lento. Para producción usa al menos `replicas: 3`.

- **No poner `resources`** → sin requests/limits, el scheduler no decide bien dónde poner los pods y un pod puede consumir todo el nodo. Define siempre `resources.requests` y `resources.limits` (guía 04).

- **Confundir `kubectl rollout undo` con `kubectl scale`** → `undo` revierte a una versión anterior de la plantilla del pod (p. ej. imagen anterior); `scale` solo cambia el número de réplicas.

- **Dos contenedores del mismo pod con el mismo puerto** → error: los contenedores de un pod comparten red y no pueden usar el mismo puerto. Usa puertos distintos o sepáralos en pods diferentes.

- **Olvidar `restartPolicy` en Jobs** → por defecto es `Always` (apropiado para Deployments). En Jobs y CronJobs usa `OnFailure` o `Never` (guía 04).

## Recursos

- [Kubernetes — Pods](https://kubernetes.io/es/docs/concepts/workloads/pods/)
- [Kubernetes — Deployments](https://kubernetes.io/es/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes — ReplicaSet](https://kubernetes.io/es/docs/concepts/workloads/controllers/replicaset/)
- [Kubernetes — Labels and Selectors](https://kubernetes.io/es/docs/concepts/overview/working-with-objects/labels/)
- [Kubernetes — Annotations](https://kubernetes.io/es/docs/concepts/overview/working-with-objects/annotations/)
- [Kubernetes — Rolling Update](https://kubernetes.io/es/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)
