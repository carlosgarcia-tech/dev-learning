# 01 — Fundamentos de Kubernetes

## Objetivos

- [ ] Entender qué es Kubernetes, qué problema resuelve y por qué se llama K8s.
- [ ] Comprender el concepto de **orquestación de contenedores** y sus ventajas frente a Docker suelto.
- [ ] Conocer la **arquitectura de un cluster**: control plane (api-server, etcd, scheduler, controller-manager) y nodos worker (kubelet, kube-proxy, container runtime).
- [ ] Instalar un cluster local con **kind** o **minikube**.
- [ ] Instalar y configurar **kubectl**, el CLI principal de K8s.
- [ ] Usar comandos básicos: `kubectl get`, `describe`, `apply`, `delete`, `logs`, `exec`.
- [ ] Entender y crear **namespaces** para aislar recursos.
- [ ] Escribir **manifiestos YAML** válidos (apiVersion, kind, metadata, spec).
- [ ] Crear tu primer **Pod** y entender por qué casi nunca se crean pods directamente.

## Apuntes

### ¿Qué es Kubernetes?

**Kubernetes** (abreviado **K8s** por las 8 letras entre la K y la s) es una plataforma de código abierto para **automatizar el despliegue, el escalado y la operación de aplicaciones en contenedores**. Lo creó Google en 2014 basándose en su sistema interno *Borg*, y hoy lo mantiene la **CNCF** (Cloud Native Computing Foundation).

#### ¿Qué problema resuelve?

Con Docker puedes empaquetar y ejecutar contenedores en una máquina. Pero en producción necesitas:

- **Ejecutar cientos de contenedores** repartidos en varios servidores.
- **Escalar automáticamente** según la carga.
- **Reiniciar contenedores** que fallan.
- **Actualizar sin downtime** (rolling updates).
- **Repartir carga** entre contenedores.
- **Gestionar secretos** y configuración.
- **Asegurar alta disponibilidad**.

Hacer todo esto a mano es inviable. Un **orquestador** como Kubernetes automatiza todas esas tareas.

#### Orquestación de contenedores

La **orquestación** es el proceso de gestionar el ciclo de vida de múltiples contenedores: dónde se ejecutan, cuántas réplicas hay, cómo se comunican, qué pasa cuando fallan y cómo se escalan.

| Sin orquestador (Docker solo) | Con orquestador (Kubernetes) |
|---|---|
| Contenedores en una sola máquina | Contenedores repartidos en un cluster |
| Escalado manual (`docker run`) | Escalado automático (HPA) |
| Sin recuperación ante fallos | Auto-reinicio de pods caídos |
| Actualizaciones manuales con downtime | Rolling updates sin downtime |
| Balanceo de carga manual | Services + kube-proxy |
| Configuración por variables de entorno | ConfigMaps y Secrets |

#### ¿Por qué K8s y no otros?

Existen otros orquestadores (Docker Swarm, Nomad, Mesos), pero Kubernetes se ha impuesto por:

- **Ecosistema masivo**: Helm, ArgoCD, Istio, Prometheus, etc.
- **Soporte multi-cloud**: AWS (EKS), Azure (AKS), GCP (GKE), on-premise.
- **De facto estándar**: la mayoría de ofertas de empleo DevOps lo exigen.
- **Comunidad activísima**: CNCF, miles de contribuidores.
- **Patrones maduros**: operators, GitOps, service mesh.

### Arquitectura del cluster

Un cluster de Kubernetes tiene dos tipos de componentes:

1. **Control Plane** (plano de control): el "cerebro" del cluster. Toma decisiones globales y responde a eventos.
2. **Nodos worker** (nodos de trabajo): las "manos". Ejecutan los contenedores de las aplicaciones.

```
┌─────────────────────────────────────────────────┐
│                  CONTROL PLANE                  │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │api-server│  │  etcd    │  │   scheduler   │  │
│  └──────────┘  └──────────┘  └───────────────┘  │
│  ┌────────────────────────────────────────────┐  │
│  │           controller-manager               │  │
│  └────────────────────────────────────────────┘  │
└───────────────────────┬─────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   WORKER 1   │ │   WORKER 2   │ │   WORKER 3   │
│ ┌──────────┐ │ │ ┌──────────┐ │ │ ┌──────────┐ │
│ │ kubelet  │ │ │ │ kubelet  │ │ │ │ kubelet  │ │
│ ├──────────┤ │ │ ├──────────┤ │ │ ├──────────┤ │
│ │kube-proxy│ │ │ │kube-proxy│ │ │ │kube-proxy│ │
│ ├──────────┤ │ │ ├──────────┤ │ │ ├──────────┤ │
│ │ runtime  │ │ │ │ runtime  │ │ │ │ runtime  │ │
│ │(containerd)│ │ │(containerd)│ │ │(containerd)│ │
│ └──────────┘ │ │ └──────────┘ │ │ └──────────┘ │
└──────────────┘ └──────────────┘ └──────────────┘
```

#### Control Plane

| Componente | Función |
|---|---|
| **kube-apiserver** | Punto de entrada único de la API de K8s. Todas las operaciones (kubectl, controladores, nodos) pasan por aquí. Expone la API REST. Valida y configura los objetos (pods, services, etc.). |
| **etcd** | Base de datos clave-valor distribuida y consistente. Guarda **todo el estado** del cluster. Es el único estado persistente; si se pierde, se pierde el cluster. Suele ir en replicación (3 nodos en producción). |
| **kube-scheduler** | Decide en qué nodo colocar cada pod nuevo en base a recursos, afinidades, taints y restricciones. No ejecuta el pod, solo lo asigna. |
| **kube-controller-manager** | Ejecuta los controladores: bucles de reconciliación que observan el estado real y lo comparan con el deseado. Incluye el *node controller*, *replication controller*, *endpoint controller*, *service account controller*. |
| **cloud-controller-manager** | (Opcional) Integridad con el proveedor cloud (balanceadores, volúmenes, rutas). |

El flujo de una operación: `kubectl` → `kube-apiserver` → valida → escribe en `etcd` → `kube-scheduler` ve el pod pendiente → lo asigna a un nodo → `kubelet` del nodo crea los contenedores.

#### Nodos worker

| Componente | Función |
|---|---|
| **kubelet** | Agente en cada nodo. Recibe instrucciones del apiserver y se asegura de que los pods asignados estén corriendo. Reporta el estado del nodo. No crea contenedores directamente: le pide al runtime que lo haga. |
| **kube-proxy** | Mantiene las reglas de red en cada nodo (iptables/IPVS) para que el tráfico a un Service llegue a los pods correctos. Implementa el balanceo de carga a nivel de red. |
| **container runtime** | Software que ejecuta los contenedores. Antes era Docker; hoy lo estándar es **containerd** (también **CRI-O**). El kubelet habla con él vía CRI (Container Runtime Interface). |

> Un cluster mínimo puede ser de un solo nodo (control plane + worker en la misma máquina), como hace minikube en modo local.

### Instalación local: kind o minikube

Para aprender K8s no necesitas un cluster cloud: puedes levantar uno local.

#### kind (Kubernetes IN Docker)

`kind` ejecuta el cluster dentro de contenedores Docker. Es rápido, ligero y el favorito para CI.

```bash
# Instalar kind (Linux)
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Crear un cluster
kind create cluster --name mi-cluster

# Ver clusters
kind get clusters

# Borrar el cluster
kind delete cluster --name mi-cluster
```

#### minikube

`minikube` crea una VM o contenedor con un cluster K8s de un nodo. Tiene muchos *addons* (ingress, dashboard, metrics-server).

```bash
# Instalar minikube (Linux)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Arrancar (detecta el driver: docker, kvm2, virtualbox...)
minikube start

# Habilitar addons útiles
minikube addons enable ingress
minikube addons enable metrics-server

# Abrir el dashboard web
minikube dashboard

# Parar y borrar
minikube stop
minikube delete
```

> Recomendación: usa **kind** si ya usas Docker y quieres algo rápido; usa **minikube** si quieres el dashboard y addons fáciles.

### kubectl

`kubectl` es la herramienta de línea de comandos para hablar con el cluster. Se instala por separado del propio cluster.

```bash
# Instalar kubectl (Linux)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verificar
kubectl version --client
```

#### Configuración (kubeconfig)

`kubectl` usa un fichero `~/.kube/config` con la información de conexión al cluster. `kind` y `minikube` lo configuran automáticamente al crear el cluster.

```bash
# Ver el contexto actual (a qué cluster apuntas)
kubectl config current-context

# Listar contextos
kubectl config get-contexts

# Cambiar de contexto
kubectl config use-context kind-mi-cluster
```

### Comandos básicos

| Comando | Qué hace |
|---|---|
| `kubectl get pods` | Lista los pods del namespace actual |
| `kubectl get pods -A` | Lista pods de **todos** los namespaces (`-A` = `--all-namespaces`) |
| `kubectl get pods -o wide` | Lista con más detalle (nodo, IP) |
| `kubectl describe pod <nombre>` | Información detallada de un pod (eventos, estado) |
| `kubectl apply -f pod.yaml` | Crea/actualiza recursos desde un fichero YAML |
| `kubectl delete -f pod.yaml` | Borra recursos definidos en un YAML |
| `kubectl delete pod <nombre>` | Borra un pod concreto |
| `kubectl logs <pod>` | Muestra los logs del contenedor |
| `kubectl logs -f <pod>` | Sigue los logs (like `tail -f`) |
| `kubectl logs <pod> -c <contenedor>` | Logs de un contenedor concreto en un multi-container pod |
| `kubectl exec -it <pod> -- sh` | Entra al pod con una shell interactiva |
| `kubectl port-forward <pod> 8080:80` | Redirige un puerto local al pod |
| `kubectl get namespaces` | Lista namespaces |
| `kubectl cluster-info` | Muestra la URL del apiserver y de los servicios del cluster |
| `kubectl get nodes` | Lista los nodos del cluster |
| `kubectl get all` | Lista todos los recursos del namespace |

```bash
# Ejemplos completos
kubectl get pods -A                          # pods de todos los namespaces
kubectl get pods -o wide                     # con IP y nodo
kubectl get pods --show-labels               # muestra las labels
kubectl describe pod nginx-pod               # detalles y eventos
kubectl logs nginx-pod                       # logs
kubectl logs -f nginx-pod                    # logs en vivo
kubectl exec -it nginx-pod -- sh             # entrar al pod
kubectl exec -it nginx-pod -- ls /app        # ejecutar comando
kubectl delete pod nginx-pod                 # borrar
kubectl get events --sort-by=.lastTimestamp   # eventos ordenados
```

> Atajo útil: `kubectl` es largo. Mucha gente añade `alias k=kubectl` y `source <(kubectl completion bash)` en su `.bashrc`.

### Namespaces

Los **namespaces** son una forma de **dividir un cluster físico en varios virtuales**. Sirven para aislar recursos por equipo, entorno (dev/staging/prod) o proyecto.

```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: desarrollo
---
apiVersion: v1
kind: Namespace
metadata:
  name: produccion
```

```bash
kubectl apply -f namespace.yaml
kubectl get namespaces
kubectl get pods -n desarrollo          # pods del namespace "desarrollo"
kubectl get pods --namespace=produccion
```

Para evitar escribir `-n` cada vez, puedes cambiar el namespace por defecto:

```bash
kubectl config set-context --current --namespace=desarrollo
```

> Los namespaces **no aíslan red**: por defecto un pod de `desarrollo` puede llegar a uno de `produccion`. El aislamiento de red se hace con **NetworkPolicies** (ver guía 05).

Hay namespaces del sistema que empiezan por `kube-` (kube-system, kube-public, kube-node-lease). Nunca toques recursos de `kube-system` salvo que sepas lo que haces.

### Manifiestos YAML

Kubernetes es **declarativo**: describes el estado deseado en ficheros YAML y el cluster se encarga de que la realidad coincida con tu descripción. Los manifiestos tienen cuatro campos obligatorios:

```yaml
apiVersion: v1          # versión de la API (v1, apps/v1, networking.k8s.io/v1...)
kind: Pod               # tipo de recurso (Pod, Deployment, Service, ConfigMap...)
metadata:
  name: mi-pod          # nombre del recurso
  labels:               # etiquetas (opcionales pero recomendadas)
    app: mi-app
spec:                   # especificación: cómo quieres que sea
  containers:
    - name: nginx
      image: nginx:1.25
      ports:
        - containerPort: 80
```

| Campo | Descripción | Ejemplos |
|---|---|---|
| `apiVersion` | Grupo y versión de la API | `v1`, `apps/v1`, `networking.k8s.io/v1`, `rbac.authorization.k8s.io/v1` |
| `kind` | Tipo de recurso | `Pod`, `Deployment`, `Service`, `ConfigMap`, `Namespace` |
| `metadata.name` | Nombre único dentro del namespace | `mi-pod`, `nginx-deployment` |
| `metadata.namespace` | Namespace (por defecto, `default`) | `desarrollo`, `produccion` |
| `metadata.labels` | Etiquetas clave-valor | `app: web`, `tier: frontend` |
| `spec` | Especificación del recurso (varía según `kind`) | depende del recurso |

Puedes separar varios documentos YAML en un mismo fichero con `---`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_URL: "postgres://localhost:5432/db"
---
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
    - name: app
      image: myapp:1.0
```

> La indentación en YAML es **con espacios, nunca tabuladores**. Dos espacios por nivel es la convención de K8s.

### Pods

El **Pod** es la unidad mínima de Kubernetes. Un pod contiene **uno o varios contenedores** que comparten red y almacenamiento, y se ejecutan siempre en el mismo nodo.

- Los contenedores de un pod comparten la misma IP y los mismos puertos (no pueden usar el mismo puerto dos contenedores del mismo pod).
- Se crean, escalan y destruyen **juntos**.
- Son **efímeros**: cuando un pod muere, no se "reinicia"; se crea uno nuevo (con otra IP).
- Por eso casi nunca se crean pods directamente: se usan **Deployments** que gestionan los pods (ver guía 02).

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.25
      ports:
        - containerPort: 80
      resources:
        requests:
          memory: "64Mi"
          cpu: "250m"
        limits:
          memory: "128Mi"
          cpu: "500m"
```

```bash
kubectl apply -f pod.yaml
kubectl get pods
kubectl get pod nginx-pod -o wide
kubectl describe pod nginx-pod
kubectl logs nginx-pod
kubectl exec -it nginx-pod -- sh
kubectl delete pod nginx-pod
```

El estado de un pod pasa por varias fases: `Pending` → `ContainerCreating` → `Running`. Si hay errores, verás `CrashLoopBackOff`, `ImagePullBackOff` o `Error`.

### Conceptos clave

| Concepto | Definición en una línea |
|---|---|
| **Cluster** | Conjunto de máquinas (nodos) que ejecutan Kubernetes |
| **Nodo** | Una máquina (física o virtual) del cluster; puede ser control plane o worker |
| **Control Plane** | Cerebro del cluster: apiserver, etcd, scheduler, controller-manager |
| **Pod** | Unidad mínima de K8s; agrupa uno o varios contenedores |
| **Manifiesto** | Fichero YAML declarativo que describe el estado deseado |
| **Namespace** | Partición virtual del cluster para aislar recursos |
| **Label** | Etiqueta clave-valor para identificar y seleccionar recursos |
| **kubectl** | CLI para interactuar con el cluster |
| **Estado deseado vs real** | Describe lo que quieres; K8s reconcilia la realidad con tu descripción |
| **CRI** | Container Runtime Interface; permite que el kubelet hable con containerd, CRI-O... |

## Errores comunes

- **Crear pods directamente en producción** → los pods son efímeros; cuando mueren no se recrean. Usa **Deployments** (guía 02) que gestionan los pods por ti.

  ```yaml
  # ❌ En producción no hagas esto sin un Deployment por encima
  kind: Pod
  ```

- **Indentación incorrecta en YAML** → `error: error parsing YAML: mapping values are not allowed here`. YAML usa **espacios, no tabuladores**. Usa 2 espacios por nivel.

  ```yaml
  # ❌ (tabulador)
  spec:
  	containers:

  # ✅ (2 espacios)
  spec:
    containers:
  ```

- **Olvidar `apiVersion` o `kind`** → el manifiesto no se aplica. Los campos `apiVersion`, `kind` y `metadata.name` son **obligatorios**.

- **Usar mayúsculas donde no toca** → `kind` y `apiVersion` son sensibles a mayúsculas: es `Pod`, no `pod`; es `apps/v1`, no `Apps/V1`.

- **Confundir `kubectl apply` con `kubectl create`** → `create` solo funciona la primera vez; `apply` es declarativo e idempotente (crea si no existe, actualiza si ya existe). Usa `apply`.

- **No especificar namespace** → todo va al namespace `default` sin darte cuenta. Usa `-n` o cambia el contexto: `kubectl config set-context --current --namespace=desarrollo`.

- **Borrar recursos del namespace `kube-system`** → puedes romper el cluster. No toques nada que empiece por `kube-` salvo que sepas lo que haces.

- **`ImagePullBackOff`** → la imagen no existe o no tienes permisos del registro. Verifica el nombre de la imagen y los secrets del registro.

- **`CrashLoopBackOff`** → el contenedor arranca y muere en bucle. Mira los logs (`kubectl logs <pod>`) y los eventos (`kubectl describe pod <pod>`).

- **Pensar que un namespace aísla la red** → los namespaces aíslan recursos, **no tráfico de red**. Para aislar red usa NetworkPolicies (guía 05).

- **Dejar recursos sin limits** → un pod puede consumir toda la CPU/memoria del nodo. Define siempre `resources.requests` y `resources.limits` (guía 04).

## Recursos

- [Documentación oficial de Kubernetes](https://kubernetes.io/es/docs/home/)
- [kind — Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [minikube — Start](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl Cheat Sheet](https://kubernetes.io/es/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Components](https://kubernetes.io/es/docs/concepts/overview/components/)
