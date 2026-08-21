# 03 — Servicios y Configuración

## Objetivos

- [ ] Entender qué es un **Service** y por qué los pods no se acceden directamente por IP.
- [ ] Crear Services de tipo **ClusterIP**, **NodePort** y **LoadBalancer**.
- [ ] Comprender **endpoints** y cómo los Services descubren a los pods.
- [ ] Usar **selectors** para asociar Services con pods.
- [ ] Entender el **DNS de servicios** y cómo se resuelven los nombres.
- [ ] Crear **headless services** para casos de StatefulSet y descubrimiento directo.
- [ ] Gestionar configuración con **ConfigMaps**.
- [ ] Gestionar datos sensibles con **Secrets**.
- [ ] Inyectar config y secrets como **variables de entorno** y como **ficheros montados**.
- [ ] Usar **volumes** básicos: `emptyDir` y `hostPath`.
- [ ] Montar volúmenes en contenedores con `volumeMounts`.

## Apuntes

### Services

Los pods son efímeros: nacen y mueren, y cada vez que nacen tienen una IP distinta. Si un pod A llama a un pod B por su IP, en cuanto B muere y renace, la IP cambia y la conexión se rompe. El **Service** resuelve esto: ofrece una **IP estable** y un **nombre DNS** que enruta el tráfico a los pods que cumplan un selector.

```
Cliente → Service (IP fija + DNS) → Pods (IPs cambiantes)
```

Un Service define:

- Un **selector** que identifica a qué pods enruta.
- Un **puerto** que escucha.
- Un **tipo** (ClusterIP, NodePort, LoadBalancer).

```yaml
# service-clusterip.yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  type: ClusterIP                    # tipo por defecto
  selector:
    app: api                         # enruta a pods con label app=api
  ports:
    - port: 80                        # puerto del service
      targetPort: 8080               # puerto del contenedor
      protocol: TCP
      name: http
```

### Tipos de Service

#### ClusterIP (por defecto)

Expone el service en una IP **interna del cluster**. Solo accesible desde dentro del cluster. Es el tipo por defecto y el más usado.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  type: ClusterIP
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 8080
```

```bash
# Desde dentro del cluster, la app es accesible en:
# http://api-service:80       (DNS)
# http://<cluster-ip>:80      (IP del service)
kubectl get svc api-service
# NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
# api-service   ClusterIP   10.96.123.45    <none>        80/TCP    1m
```

#### NodePort

Expone el service en un puerto **de cada nodo** (por defecto 30000-32767). Accesible desde fuera del cluster en `<IP-del-nodo>:<NodePort>`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-nodeport
spec:
  type: NodePort
  selector:
    app: api
  ports:
    - port: 80                        # puerto interno del service
      targetPort: 8080               # puerto del contenedor
      nodePort: 30080                # puerto en el nodo (30000-32767)
```

```bash
# Acceso desde fuera del cluster:
# http://<IP-del-nodo>:30080
minikube service api-nodeport --url   # obtiene la URL en minikube
```

> NodePort es útil para pruebas, pero en producción se usa **Ingress** (guía 05) para exponer HTTP/HTTPS de forma limpia.

#### LoadBalancer

Crea un **balanceador de carga externo** en el proveedor cloud (AWS ELB, Azure LB, GCP LB). En local, `minikube tunnel` o `kind` con MetalLB lo simulan.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 8080
```

```bash
kubectl get svc api-loadbalancer
# NAME                TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)        AGE
# api-loadbalancer    LoadBalancer   10.96.45.67   203.0.113.10     80:31234/TCP   2m
```

| Tipo | Accesible desde | Cuándo usar |
|---|---|---|
| **ClusterIP** | Dentro del cluster | Comunicación interna entre microservicios (más común) |
| **NodePort** | IP del nodo + puerto alto (30000+) | Pruebas locales, acceso externo rápido |
| **LoadBalancer** | IP externa del cloud | Exponer un servicio TCP/UDP en producción |
| **Ingress** (guía 05) | HTTP/HTTPS con dominio y TLS | Exponer apps web en producción |

### Endpoints y selectors

Un Service enruta el tráfico a los pods que coinciden con su `selector`. K8s mantiene automáticamente un recurso **Endpoints** (o **EndpointSlice**) que lista las IPs de los pods seleccionados.

```bash
kubectl get endpoints api-service
# NAME          ENDPOINTS                     AGE
# api-service   10.244.1.2:8080,10.244.1.3:8080   1m
```

Si no hay pods que cumplan el selector, el service no tiene endpoints y el tráfico no llega a ningún sitio:

```bash
kubectl describe svc api-service
# ...
# Endpoints:         <none>    ← problema: no hay pods con la label app=api
```

> Si un service no enruta tráfico, comprueba: (1) que el selector del service coincide con las labels del pod, y (2) que los pods están `Running` y tienen el `targetPort` correcto.

### DNS de servicios

Kubernetes incluye un **servidor DNS interno** (CoreDNS). Cada service recibe un nombre DNS:

```
<nombre-service>.<namespace>.svc.cluster.local
```

Por ejemplo, el service `api-service` en el namespace `default` se resuelve como:

```
api-service                        # mismo namespace
api-service.default                 # explícito
api-service.default.svc.cluster.local   # FQDN
```

Los pods pueden llamarse entre sí por nombre de service sin saber la IP:

```bash
# Dentro de un pod:
curl http://api-service:80
curl http://api-service.default:80
```

> El DNS de servicios es la base de la comunicación entre microservicios en K8s. En vez de configurar IPs, usas nombres.

### Headless services

Un **headless service** (`clusterIP: None`) no asigna una IP al service. En su lugar, el DNS devuelve directamente las IPs de los pods. Se usa en **StatefulSets** donde cada pod necesita su identidad propia.

```yaml
# headless-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: db-headless
spec:
  clusterIP: None              # esto lo hace headless
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
```

```bash
# Un DNS normal devuelve la IP del service:
nslookup api-service
# Name:    api-service.default.svc.cluster.local
# Address: 10.96.123.45     ← IP del service

# Un headless devuelve las IPs de los pods:
nslookup db-headless
# Name:    db-headless.default.svc.cluster.local
# Address: 10.244.1.2       ← IP del pod 0
# Address: 10.244.1.3       ← IP del pod 1
```

Con StatefulSets, cada pod tiene además un nombre DNS estable:

```
<nombre-pod>.<nombre-headless-service>.<namespace>.svc.cluster.local
# postgres-0.db-headless.default.svc.cluster.local
# postgres-1.db-headless.default.svc.cluster.local
```

### ConfigMaps

Un **ConfigMap** almacena datos de configuración **no sensibles** en pares clave-valor. Permite separar la configuración del código de la imagen.

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_HOST: "postgres-service"
  DATABASE_PORT: "5432"
  LOG_LEVEL: "info"
  APP_ENV: "produccion"
  config.yaml: |
    server:
      port: 8080
      timeout: 30
    features:
      cache: true
      metrics: false
```

#### Inyección como variables de entorno

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-con-env
spec:
  containers:
    - name: app
      image: nginx:1.25
      env:
        - name: DATABASE_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DATABASE_HOST
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: LOG_LEVEL
```

O cargar **todas** las claves del ConfigMap de golpe:

```yaml
      envFrom:
        - configMapRef:
            name: app-config
```

#### Inyección como fichero montado

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-con-volumen
spec:
  containers:
    - name: app
      image: nginx:1.25
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
          readOnly: true
  volumes:
    - name: config-volume
      configMap:
        name: app-config
```

Esto crea un fichero por cada clave del ConfigMap dentro de `/etc/config`:

```bash
ls /etc/config
# DATABASE_HOST  DATABASE_PORT  LOG_LEVEL  APP_ENV  config.yaml

cat /etc/config/LOG_LEVEL
# info
```

### Secrets

Un **Secret** almacena datos **sensibles** (contraseñas, tokens, certificados). Está codificado en base64 (no cifrado por defecto) y se gestiona de forma separada del ConfigMap.

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  DATABASE_PASSWORD: cGFzc3dvcmQxMjM=    # base64 de "password123"
  API_KEY: bWlfa2V5X3NlY3JldGE=           # base64 de "mi_key_secreta"
```

Para codificar en base64:

```bash
echo -n 'password123' | base64
# cGFzc3dvcmQxMjM=

echo -n 'password123' | base64 -d     # decodificar
```

> Desde K8s 1.21 puedes usar `stringData` para no codificar a mano:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
stringData:
  DATABASE_PASSWORD: "password123"
  API_KEY: "mi_key_secreta"
```

#### Inyección de Secrets

Igual que ConfigMaps, se pueden inyectar como variables o como ficheros:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-con-secret
spec:
  containers:
    - name: app
      image: nginx:1.25
      env:
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DATABASE_PASSWORD
      volumeMounts:
        - name: secret-volume
          mountPath: /etc/secret
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: app-secret
```

> ⚠️ Los Secrets base64 **no son cifrado**. Cualquiera con acceso al cluster puede decodificarlos. En producción usa herramientas como **External Secrets**, **Sealed Secrets** o un KMS (ver guía 05).

### Variables de entorno

Además de ConfigMaps y Secrets, puedes definir variables de entorno directamente y usar campos del propio pod:

```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      env:
        - name: ENTORNO
          value: "produccion"
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: CPU_LIMIT
          valueFrom:
            resourceFieldRef:
              resource: limits.cpu
```

### Volumes

Los contenedores son efímeros: cuando un contenedor muere, sus ficheros se pierden. Los **volumes** permiten compartir y persistir datos.

#### emptyDir

Un volumen `emptyDir` se crea vacío cuando el pod arranca y se borra cuando el pod muere. Útil para compartir datos entre contenedores del mismo pod.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-emptydir
spec:
  containers:
    - name: writer
      image: busybox:1.36
      command: ["sh", "-c", "while true; do echo $(date) >> /data/log.txt; sleep 5; done"]
      volumeMounts:
        - name: shared-data
          mountPath: /data
    - name: reader
      image: busybox:1.36
      command: ["sh", "-c", "tail -f /data/log.txt"]
      volumeMounts:
        - name: shared-data
          mountPath: /data
  volumes:
    - name: shared-data
      emptyDir: {}
```

#### hostPath

Monta un directorio del **nodo host** en el pod. Útil para herramientas de nodo o pruebas, pero **peligroso en producción** (acopla el pod al nodo y puede acceder a ficheros del host).

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-hostpath
spec:
  containers:
    - name: app
      image: nginx:1.25
      volumeMounts:
        - name: host-data
          mountPath: /usr/share/nginx/html
          readOnly: true
  volumes:
    - name: host-data
      hostPath:
        path: /var/www
        type: Directory
```

| Tipo de volumen | Duración | Uso típico |
|---|---|---|
| `emptyDir` | Vida del pod | Compartir datos entre contenedores del mismo pod |
| `hostPath` | Permanente en el nodo | Acceso a ficheros del host (peligroso en prod) |
| `configMap` | Configuración | Montar ConfigMap como ficheros |
| `secret` | Datos sensibles | Montar Secret como ficheros |
| `persistentVolumeClaim` | Persistente (guía 04) | Almacenamiento duradero independiente del pod |

#### volumeMounts

El patrón es siempre: definir el volumen en `spec.volumes` y montarlo en `spec.containers[].volumeMounts`:

```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: mi-volumen          # debe coincidir con el nombre del volume
          mountPath: /app/data      # dónde se monta en el contenedor
          readOnly: true            # opcional
  volumes:
    - name: mi-volumen               # el mismo nombre
      emptyDir: {}
```

### Conceptos clave

| Concepto | Definición |
|---|---|
| **Service** | Abstracción que da IP y DNS estables a un conjunto de pods |
| **ClusterIP** | IP interna del cluster; solo accesible desde dentro |
| **NodePort** | Expone el service en un puerto del nodo (30000-32767) |
| **LoadBalancer** | Crea un balanceador externo en el cloud |
| **Endpoints** | Lista de IPs de los pods detrás de un service |
| **Headless service** | Service sin IP (`clusterIP: None`); DNS devuelve IPs de pods |
| **DNS de servicios** | CoreDNS resuelve nombres `<service>.<namespace>.svc.cluster.local` |
| **ConfigMap** | Almacena configuración no sensible en pares clave-valor |
| **Secret** | Almacena datos sensibles (base64, no cifrado por defecto) |
| **Volume** | Almacenamiento compartido/persistente para contenedores |
| **emptyDir** | Volumen efímero que vive lo mismo que el pod |
| **hostPath** | Monta un directorio del nodo host |

## Errores comunes

- **Selector del service que no coincide con las labels del pod** → el service no tiene endpoints y el tráfico no llega a ningún sitio.

  ```bash
  kubectl describe svc api-service
  # Endpoints: <none>   ← el selector no coincide con ningún pod
  ```

- **`targetPort` incorrecto** → el service escucha en `port` y enruta a `targetPort`. Si el contenedor escucha en 8080 pero el service dice `targetPort: 80`, la conexión se rechaza.

- **Pensar que un NodePort da una URL pública** → NodePort solo expone el puerto en los nodos. Para acceso externo real necesitas la IP del nodo (en local, `minikube ip` + nodePort). En cloud usa LoadBalancer o Ingress.

- **Secrets en base64 pensados como cifrado** → `base64` es codificación, **no cifrado**. Cualquiera con `kubectl get secret -o yaml` puede decodificarlo. Usa Sealed Secrets o External Secrets en producción.

- **Montar un ConfigMap/Secret sin `readOnly: true`** → si el contenedor escribe en el volumen, K8s puede sobrescribir los cambios al actualizar el ConfigMap. Siempre monta config como `readOnly: true`.

- **Olvidar que `emptyDir` se borra al morir el pod** → si necesitas persistencia real, usa `persistentVolumeClaim` (guía 04). `emptyDir` es solo para compartir entre contenedores.

- **No usar FQDN entre namespaces** → `api-service` funciona solo dentro del mismo namespace. Si el pod A está en `frontend` y el service B está en `backend`, usa `api-service.backend` o el FQDN completo.

- **Usar `hostPath` en producción** → acopla el pod al nodo (si el pod se mueve a otro nodo, el dato no está) y es un riesgo de seguridad. Usa PVC en su lugar.

- **Confundir `port` y `nodePort`** → `port` es el puerto del service (interno); `nodePort` es el puerto del nodo (30000-32767) solo en services tipo NodePort/LoadBalancer.

- **Variables de entorno del ConfigMap que no se actualizan** → las variables inyectadas con `envFrom` o `env` se cargan al arrancar el pod. Si cambias el ConfigMap, necesitas reiniciar el pod. En cambio, los ficheros montados **sí** se actualizan automáticamente (tras unos segundos).

## Recursos

- [Kubernetes — Service](https://kubernetes.io/es/docs/concepts/services-networking/service/)
- [Kubernetes — DNS for Services and Pods](https://kubernetes.io/es/docs/concepts/services-networking/dns-pod-service/)
- [Kubernetes — ConfigMap](https://kubernetes.io/es/docs/concepts/configuration/configmap/)
- [Kubernetes — Secret](https://kubernetes.io/es/docs/concepts/configuration/secret/)
- [Kubernetes — Volumes](https://kubernetes.io/es/docs/concepts/storage/volumes/)
- [Kubernetes — Connecting Applications with Services](https://kubernetes.io/es/docs/concepts/services-networking/connect-applications-service/)
