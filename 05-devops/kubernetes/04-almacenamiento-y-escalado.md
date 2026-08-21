# 04 — Almacenamiento y Escalado

## Objetivos

- [ ] Entender el modelo de almacenamiento de K8s: **PersistentVolume** (PV) y **PersistentVolumeClaim** (PVC).
- [ ] Conocer las **StorageClasses** y el aprovisionamiento dinámico de volúmenes.
- [ ] Crear **StatefulSets** para aplicaciones con estado.
- [ ] Desplegar **DaemonSets** para ejecutar un pod en cada nodo.
- [ ] Usar **Jobs** y **CronJobs** para tareas batch.
- [ ] Entender y configurar el **Horizontal Pod Autoscaler (HPA)**.
- [ ] Conocer el **Vertical Pod Autoscaler (VPA)** y el **Cluster Autoscaler**.
- [ ] Definir **requests y limits** de CPU y memoria.
- [ ] Entender las **métricas** que alimentan el autoescalado.

## Apuntes

### PersistentVolumes y PersistentVolumeClaims

En K8s, el almacenamiento duradero se gestiona en dos capas:

- **PersistentVolume (PV)**: un recurso de almacenamiento en el cluster, provisionado por un admin o dinámicamente. Es un objeto del cluster.
- **PersistentVolumeClaim (PVC)**: una "petición" de almacenamiento por parte de un usuario. Es como reservar espacio: "necesito 5Gi con acceso ReadWriteOnce".

El flujo es: el usuario crea un **PVC** pidiendo almacenamiento → K8s busca un **PV** que cumpla → los vincula → el pod monta el PVC.

```
Pod → PVC → PV → almacenamiento real (disco del nodo, EBS, NFS...)
```

#### PersistentVolume (estático)

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce            # montable por un nodo a la vez
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/data
```

| AccessMode | Significado |
|---|---|
| `ReadWriteOnce` (RWO) | Lectura/escritura por **un solo nodo** |
| `ReadOnlyMany` (ROX) | Solo lectura por **múltiples nodos** |
| `ReadWriteMany` (RWX) | Lectura/escritura por **múltiples nodos** (requiere NFS, CephFS...) |

| ReclaimPolicy | Qué pasa al borrar el PVC |
|---|---|
| `Retain` | El PV se queda (datos conservados); hay que limpiarlo a mano |
| `Delete` | El PV y el volumen subyacente se borran |
| `Recycle` | (obsoleto) Limpia el volumen para reutilizarlo |

#### PersistentVolumeClaim

```yaml
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

#### Uso en un Pod

```yaml
# pod-con-pvc.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-con-pvc
spec:
  containers:
    - name: app
      image: nginx:1.25
      volumeMounts:
        - name: storage
          mountPath: /usr/share/nginx/html
  volumes:
    - name: storage
      persistentVolumeClaim:
        claimName: pvc-data
```

### StorageClasses y aprovisionamiento dinámico

Crear PVs a mano es tedioso. Las **StorageClasses** permiten el **aprovisionamiento dinámico**: al crear un PVC, K8s pide al provisionador que cree el volumen automáticamente.

```yaml
# storageclass.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/no-provisioner   # o: k8s.io/minikube-hostpath, kubernetes.io/aws-ebs...
volumeBindingMode: WaitForFirstConsumer
```

```bash
# En minikube, hay StorageClasses predefinidas:
kubectl get storageclass
# NAME                PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE
# standard (default)  k8s.io/minikube-hostpath   Delete          Immediate
```

Con una StorageClass por defecto, el PVC no necesita especificar PV:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dinamico
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard    # si es la default, se puede omitir
  resources:
    requests:
      storage: 2Gi
```

```bash
kubectl apply -f pvc.yaml
kubectl get pvc
# NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# pvc-dinamico   Bound    pvc-12345-67890                            2Gi        RWO            standard       5s
kubectl get pv
# NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM
# pvc-12345-67890                            2Gi        RWO            Delete           Bound    default/pvc-dinamico
```

### StatefulSets

Un **StatefulSet** es como un Deployment, pero para aplicaciones con estado (bases de datos, colas, sistemas distribuidos). Garantiza:

- Nombres estables: `app-0`, `app-1`, `app-2` (no nombres aleatorios).
- DNS estable: cada pod tiene su entrada DNS.
- Almacenamiento estable: cada pod tiene su propio volumen persistente.
- Orden de arranque y apagado: `app-0` antes que `app-1`, etc.

```yaml
# statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres          # headless service asociado
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_PASSWORD
              value: "secret"
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:          # un PVC por pod, creado automáticamente
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 5Gi
```

> El `volumeClaimTemplates` crea un PVC distinto para cada pod: `data-postgres-0`, `data-postgres-1`, `data-postgres-2`. Cada pod tiene su propio volumen.

Necesita un **headless service** para el DNS:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  clusterIP: None
  selector:
    app: postgres
  ports:
    - port: 5432
```

Cada pod es accesible por DNS estable:

```
postgres-0.postgres.default.svc.cluster.local
postgres-1.postgres.default.svc.cluster.local
```

| | Deployment | StatefulSet |
|---|---|---|
| Nombres de pods | Aleatorios (`app-abc123`) | Ordenados (`app-0`, `app-1`) |
| DNS individual | No | Sí |
| Almacenamiento | Compartido o efímero | Un PVC por pod, estable |
| Orden | Paralelo | Secuencial (0, 1, 2...) |
| Uso | Apps sin estado | Bases de datos, clústeres |

### DaemonSets

Un **DaemonSet** garantiza que **cada nodo** ejecute una copia de un pod. Se usa para agentes de monitorización, logging, red (CNI) o almacenamiento.

```yaml
# daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
  labels:
    app: log-collector
spec:
  selector:
    matchLabels:
      app: log-collector
  template:
    metadata:
      labels:
        app: log-collector
    spec:
      containers:
        - name: fluentd
          image: fluent/fluentd:v1.16
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "200m"
              memory: "256Mi"
          volumeMounts:
            - name: varlog
              mountPath: /var/log
              readOnly: true
      volumes:
        - name: varlog
          hostPath:
            path: /var/log
```

```bash
kubectl get daemonset log-collector
# NAME            DESIRED   CURRENT   READY   NODE-SELECTOR   AGE
# log-collector   3         3         3       <none>           1m

# Hay un pod en cada nodo:
kubectl get pods -l app=log-collector -o wide
# NAME                   READY   STATUS    NODE
# log-collector-abc12   1/1     Running   node-1
# log-collector-def34   1/1     Running   node-2
# log-collector-ghi56   1/1     Running   node-3
```

### Jobs y CronJobs

#### Job

Un **Job** crea uno o varios pods y espera a que terminen con éxito. Ideal para tareas batch: migraciones, backups, procesamiento.

```yaml
# job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  completions: 1                  # cuántos pods deben terminar con éxito
  parallelism: 1                  # cuántos pods en paralelo
  backoffLimit: 3                 # reintentos antes de fallar
  template:
    spec:
      restartPolicy: OnFailure    # o Never
      containers:
        - name: migration
          image: migrate/migrate:v4.16
          command: ["migrate", "-path", "/migrations", "-database", "postgres://...", "up"]
```

```bash
kubectl get jobs
# NAME          COMPLETIONS   DURATION   AGE
# db-migration  1/1           15s        1m
```

#### CronJob

Un **CronJob** ejecuta Jobs en un horario (sintaxis cron).

```yaml
# cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-db
spec:
  schedule: "0 2 * * *"           # todos los días a las 2:00 AM
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: backup
              image: postgres:16
              command: ["pg_dump", "-h", "postgres", "-U", "admin", "midb", "-f", "/backup/db.sql"]
              volumeMounts:
                - name: backup
                  mountPath: /backup
          volumes:
            - name: backup
              emptyDir: {}
```

| Campo cron | Significado |
|---|---|
| `0 2 * * *` | A las 2:00 AM todos los días |
| `*/5 * * * *` | Cada 5 minutos |
| `0 0 * * 0` | A medianoche los domingos |
| `0 0 1 * *` | El día 1 de cada mes a medianoche |

### Recursos: requests y limits

Cada contenedor puede definir cuánta CPU y memoria necesita y cuál es su límite. Esto es **fundamental** para que el scheduler coloque bien los pods y el HPA funcione.

```yaml
resources:
  requests:                       # lo que el pod garantiza tener
    cpu: "100m"                   # 100 milicores = 0.1 núcleo
    memory: "128Mi"               # 128 mebibytes
  limits:                         # el máximo que puede consumir
    cpu: "250m"
    memory: "256Mi"
```

| Unidad | Significado |
|---|---|
| `100m` | 100 milicores (0.1 CPU) |
| `1` | 1 núcleo de CPU |
| `128Mi` | 128 mebibytes (1 Mi = 1024 Ki) |
| `1Gi` | 1 gibibyte (1024 Mi) |

- **requests**: lo que K8s reserva para el pod. El scheduler lo usa para decidir dónde ponerlo.
- **limits**: el máximo que el pod puede usar. Si lo supera, CPU se acelera (throttle) y memory mata al contenedor (OOMKilled).

```bash
kubectl describe pod mi-pod
# ...
# Limits:      cpu: 250m, memory: 256Mi
# Requests:     cpu: 100m, memory: 128Mi

# Ver uso real de recursos:
kubectl top pod
# NAME       CPU(cores)   MEMORY(bytes)
# mi-pod     50m          100Mi
```

> `OOMKilled` significa que el contenedor superó su `limits.memory` y K8s lo mató. Si lo ves, sube el límite o revisa fugas de memoria.

### Horizontal Pod Autoscaler (HPA)

El **HPA** escala el número de réplicas de un Deployment según la carga (CPU, memoria o métricas personalizadas). Necesita el **Metrics Server** instalado en el cluster.

```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-deployment
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70    # escala si la CPU media supera el 70%
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
```

```bash
# Habilitar metrics-server en minikube
minikube addons enable metrics-server

# Aplicar el HPA
kubectl apply -f hpa.yaml
kubectl get hpa
# NAME      REFERENCE                  TARGETS   MINPODS   MAXPODS   REPLICAS
# api-hpa   Deployment/api-deployment  30%/40%   2         10        2

# Generar carga para verlo escalar:
kubectl run -i --tty load-generator --rm --image=busybox:1.36 -- /bin/sh -c "while true; do wget -q -O- http://api-service; done"
```

#### Comportamiento del HPA

- Si CPU media > 70%: añade réplicas (hasta `maxReplicas`).
- Si CPU media < 70%: quita réplicas (hasta `minReplicas`).
- El cálculo es: `réplicas deseadas = ceil(réplicas actuales × (uso actual / objetivo))`.

> Para que el HPA funcione, el Deployment **debe** tener `resources.requests.cpu` definido. Sin requests, el HPA no puede calcular el porcentaje de uso.

### Vertical Pod Autoscaler (VPA)

El **VPA** ajusta automáticamente los `requests` y `limits` de CPU/memoria de los pods según su uso histórico. Útil cuando no sabes cuánto recursos necesita una app.

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: api-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: api-deployment
  updatePolicy:
    updateMode: Auto        # Auto, Initial, Off
```

> VPA y HPA no deben usarse juntos sobre la misma métrica (CPU/memoria), porque entrarían en conflicto. Usa HPA para escalado horizontal y VPA para ajustar requests.

### Cluster Autoscaler

El **Cluster Autoscaler** añade o quita nodos del cluster cuando:

- Hay pods `Pending` por falta de recursos → añade un nodo.
- Hay nodos infrautilizados → los drena y los elimina.

No es un recurso de K8s: es un componente externo que se instala en el cluster y habla con la API del cloud (EKS, GKE, AKS) para pedir más nodos.

> En local con kind/minikube no se usa Cluster Autoscaler; es para clusters cloud.

### Conceptos clave

| Concepto | Definición |
|---|---|
| **PersistentVolume (PV)** | Recurso de almacenamiento en el cluster |
| **PersistentVolumeClaim (PVC)** | Petición de almacenamiento por parte de un usuario |
| **StorageClass** | Define cómo se provisionan los volúmenes dinámicamente |
| **Aprovisionamiento dinámico** | K8s crea el PV automáticamente al crear el PVC |
| **StatefulSet** | Controller para apps con estado; pods con nombre y almacenamiento estables |
| **DaemonSet** | Controller que ejecuta un pod en cada nodo |
| **Job** | Tarea batch que termina con éxito |
| **CronJob** | Job programado con sintaxis cron |
| **HPA** | Escala réplicas según la carga (CPU/memoria) |
| **VPA** | Ajusta requests/limits según el uso |
| **Cluster Autoscaler** | Añade/quita nodos del cluster según necesidad |
| **requests** | Recursos garantizados para un contenedor |
| **limits** | Recursos máximos que un contenedor puede usar |

## Errores comunes

- **PVC `Pending`** → no hay PV que cumpla o la StorageClass no provisiona. Comprueba `kubectl get pv` y `kubectl describe pvc`.

- **Usar Deployment para una base de datos** → los Deployments no garantizan almacenamiento estable. Para bases de datos usa **StatefulSet**.

- **Olvidar `serviceName` en un StatefulSet** → el StatefulSet requiere un headless service para el DNS. Sin `serviceName`, los pods no tienen DNS individual estable.

- **HPA que no escala** → faltan `resources.requests.cpu` en el Deployment, o el Metrics Server no está instalado. Verifica con `kubectl top pods`.

- **`OOMKilled`** → el contenedor superó su `limits.memory`. Sube el límite o revisa fugas de memoria.

- **CPU throttle** → el contenedor está al 100% de su `limits.cpu`. Sube el límite o escala más réplicas.

- **Pensar que `ReadWriteMany` funciona en cualquier disco** → RWX requiere un sistema de ficheros compartido (NFS, CephFS). Un disco EBS solo soporta `ReadWriteOnce`.

- **StatefulSet que no elimina sus PVCs al borrarse** → por diseño, los PVCs de un StatefulSet **no se borran** al borrar el StatefulSet (para protección de datos). Hay que borrarlos a mano.

- **Job que se ejecuta para siempre** → define `activeDeadlineSeconds` para limitar la duración y `backoffLimit` para los reintentos.

- **No definir `resources` en producción** → sin requests, el scheduler puede sobrecargar nodos; sin limits, un pod puede consumir todo el nodo. Define siempre ambos.

## Recursos

- [Kubernetes — PersistentVolume](https://kubernetes.io/es/docs/concepts/storage/persistent-volumes/)
- [Kubernetes — StorageClass](https://kubernetes.io/es/docs/concepts/storage/storage-classes/)
- [Kubernetes — StatefulSet](https://kubernetes.io/es/docs/concepts/workloads/controllers/statefulset/)
- [Kubernetes — DaemonSet](https://kubernetes.io/es/docs/concepts/workloads/controllers/daemonset/)
- [Kubernetes — Job](https://kubernetes.io/es/docs/concepts/workloads/controllers/job/)
- [Kubernetes — Horizontal Pod Autoscaler](https://kubernetes.io/es/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Kubernetes — Managing Resources](https://kubernetes.io/es/docs/concepts/configuration/manage-resources-containers/)
