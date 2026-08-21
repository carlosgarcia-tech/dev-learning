# Proyecto Final — Despliegue de microservicios en Kubernetes

- **Dificultad:** ⭐⭐⭐⭐⭐ (5/5)
- **Tiempo estimado:** 4-6 horas

## Contexto

Imagina que trabajas para **TiendaGalaxia**, una startup de comercio electrónico que quiere
llevar su plataforma a producción en Kubernetes. La aplicación es una **tienda online** compuesta
por **3 microservicios**:

1. **Frontend** — servidor web `nginx` que sirve una página HTML estática que consume la API.
2. **Backend** — servicio en **Python/Flask** que expone la API de productos (`/api/productos`).
3. **Base de datos** — **PostgreSQL** que almacena el catálogo de productos.

Tu misión es desplegar la arquitectura completa en un cluster Kubernetes (kind/minikube),
aplicando todas las mejores prácticas de producción: configuración externalizada, secretos,
almacenamiento persistente, autoescalado, sondas de salud, control de tráfico con Ingress y
NetworkPolicies, control de acceso (RBAC), y políticas de resiliencia (PDB y ResourceQuota).

> Este proyecto es **integrador**: combina los conceptos de los 30 ejercicios anteriores en un
> único despliegue realista. Los archivos de la carpeta [`microservicios-k8s/`](./microservicios-k8s/)
> están **incompletos a propósito** (marcados con `# TODO`) para que tú los completes.

## Arquitectura

```
                       ┌─────────────────┐
        Usuario ──────►│     Ingress     │   host: tienda.local
        (navegador)    │  (nginx-ingress)│
                       └────────┬────────┘
                           ┌────┴────┐
                     /api  │         │  /
                           ▼         ▼
                   ┌───────────┐  ┌────────────┐
                   │  backend  │  │  frontend  │
                   │  (Flask)  │  │  (nginx)   │
                   │   :5000   │  │    :80     │
                   │ replicas 2│  │ replicas 3 │
                   │  + HPA    │  │            │
                   └─────┬─────┘  └────────────┘
                         │ 5432 / TCP
                         ▼
                   ┌───────────┐
                   │ postgres  │
                   │   (DB)    │
                   │  :5432    │
                   │ StatefulSet
                   └─────┬─────┘
                         │
                         ▼
                 ┌─────────────────┐
                 │ PersistentVolume│  5Gi (catálogo persistente)
                 │  + PVC          │
                 └─────────────────┘

  Configuración:  ConfigMap (tienda-config, backend-probes)
  Secretos:       Secret (tienda-secrets)
  Seguridad:      RBAC (ServiceAccount, Role, RoleBinding)
  Red:            NetworkPolicy (frontend → backend → db, deny por defecto)
  Resiliencia:    PDB (backend, frontend) + ResourceQuota (namespace)
```

**Flujo de tráfico y datos:**

- El navegador accede a `http://tienda.local/` (Ingress enruta al frontend).
- El frontend (HTML/JS) llama a `/api/productos` (Ingress enruta `/api/*` al backend).
- El backend consulta PostgreSQL en `postgres:5432`.
- La base de datos persiste su contenido en un PersistentVolume.
- Las NetworkPolicies garantizan que solo el frontend habla con el backend y solo el backend
  habla con la base de datos.

## Requisitos

Implementa y aplica los siguientes recursos dentro del namespace `tienda-online`:

- [ ] Un **Namespace** `tienda-online` con labels descriptivos.
- [ ] Un **ConfigMap** `tienda-config` con la configuración no sensible de la app.
- [ ] Un **Secret** `tienda-secrets` con contraseñas (postgres, API key, JWT).
- [ ] Un **StatefulSet** `postgres` (PostgreSQL) con sondas y almacenamiento persistente.
- [ ] Un **Headless Service** `postgres` (necesario para el StatefulSet).
- [ ] Un **PersistentVolume** y un **PersistentVolumeClaim** para los datos de postgres.
- [ ] Un **Deployment** `backend` (Flask) con sondas liveness/readiness y `resources`.
- [ ] Un **Service** ClusterIP `backend`.
- [ ] Un **HorizontalPodAutoscaler** `backend` (CPU/memoria).
- [ ] Un **ConfigMap** `backend-probes` con la configuración de las sondas.
- [ ] Un **Deployment** `frontend` (nginx) con sondas y `resources`.
- [ ] Un **Service** ClusterIP `frontend`.
- [ ] Un **Ingress** que enrute `/` al frontend y `/api` al backend.
- [ ] Una **NetworkPolicy** que permita `frontend → backend → db` (y deniegue el resto).
- [ ] Un **RBAC**: ServiceAccount, Role y RoleBinding.
- [ ] Un **PodDisruptionBudget** para backend y frontend.
- [ ] Un **ResourceQuota** para el namespace.
- [ ] Los tests pasan: `bash microservicios-k8s/test.sh`

## Fases

> Recomendación: completa cada fase en orden. Al final de cada una, aplica los manifiestos con
> `kubectl apply -f ...` y verifica el estado antes de continuar.

### Fase 1 — Namespace y configuración

Crea el namespace y los objetos de configuración:

- `00-namespace.yaml` → Namespace `tienda-online`.
- `01-configmap.yaml` → ConfigMap `tienda-config`.
- `02-secret.yaml` → Secret `tienda-secrets`.

```bash
kubectl apply -f microservicios-k8s/00-namespace.yaml
kubectl apply -f microservicios-k8s/01-configmap.yaml
kubectl apply -f microservicios-k8s/02-secret.yaml
kubectl -n tienda-online get configmap,secret
```

### Fase 2 — Base de datos (StatefulSet + PV)

Despliega PostgreSQL de forma que sus datos sobrevivan a reinicios:

- `03-db/pv-pvc.yaml` → PersistentVolume y PersistentVolumeClaim (5 Gi).
- `03-db/service.yaml` → Headless Service (clusterIP: None).
- `03-db/statefulset.yaml` → StatefulSet con env desde ConfigMap/Secret, sondas y volumen.

```bash
kubectl apply -f microservicios-k8s/03-db/
kubectl -n tienda-online get statefulset,pvc,pv
kubectl -n tienda-online rollout status statefulset/postgres
```

### Fase 3 — Backend (Deployment + probes + HPA)

Despliega la API Flask con autoescalado:

- `04-backend/probes-config.yaml` → ConfigMap `backend-probes`.
- `04-backend/deployment.yaml` → Deployment con sondas HTTP, env y resources.
- `04-backend/service.yaml` → Service ClusterIP `backend`.
- `04-backend/hpa.yaml` → HPA (CPU/memoria).

```bash
kubectl apply -f microservicios-k8s/04-backend/
kubectl -n tienda-online get deploy,svc,hpa
kubectl -n tienda-online rollout status deployment/backend
```

### Fase 4 — Frontend (Deployment)

Despliega el frontend nginx:

- `05-frontend/deployment.yaml` → Deployment con sondas y resources.
- `05-frontend/service.yaml` → Service ClusterIP `frontend`.

```bash
kubectl apply -f microservicios-k8s/05-frontend/
kubectl -n tienda-online get deploy,svc -l component=frontend
```

### Fase 5 — Ingress y networking

Expón la app al exterior y enruta el tráfico:

- `06-ingress.yaml` → Ingress (`/` → frontend, `/api` → backend).

```bash
kubectl apply -f microservicios-k8s/06-ingress.yaml
kubectl -n tienda-online get ingress
# Añade a /etc/hosts:  127.0.0.1  tienda.local
```

### Fase 6 — Seguridad (RBAC + NetworkPolicy)

Aísla el tráfico y define permisos:

- `07-networkpolicy.yaml` → NetworkPolicy (frontend → backend → db, deny por defecto).
- `08-rbac.yaml` → ServiceAccount, Role y RoleBinding.

```bash
kubectl apply -f microservicios-k8s/07-networkpolicy.yaml
kubectl apply -f microservicios-k8s/08-rbac.yaml
kubectl -n tienda-online get networkpolicy,sa,role,rolebinding
```

### Fase 7 — Producción (PDB + Quotas)

Aplica resiliencia y límites de capacidad:

- `09-pdb.yaml` → PodDisruptionBudget para backend y frontend.
- `10-resourcequota.yaml` → ResourceQuota del namespace.

```bash
kubectl apply -f microservicios-k8s/09-pdb.yaml
kubectl apply -f microservicios-k8s/10-resourcequota.yaml
kubectl -n tienda-online get pdb,resourcequota
```

## Criterios de aceptación

- [ ] Todos los pods están `Running` y las sondas `Ready`.
- [ ] `kubectl -n tienda-online get all` muestra los 3 microservicios correctos.
- [ ] El PVC de postgres está `Bound` y los datos persisten tras reiniciar el pod.
- [ ] El HPA referencia al Deployment correcto y tiene `minReplicas < maxReplicas`.
- [ ] El Ingress enruta `/` al frontend y `/api` al backend.
- [ ] Las NetworkPolicies permiten `frontend → backend → db` y deniegan el resto.
- [ ] El ServiceAccount está vinculado a un Role y RoleBinding.
- [ ] Los PDB y el ResourceQuota están aplicados.
- [ ] Navegar a `http://tienda.local/` muestra la tienda y carga productos de la API.
- [ ] `bash microservicios-k8s/test.sh` imprime `OK Tests pasaron`.

## Cómo ejecutar

### Opción A — kind (recomendado)

```bash
# 1. Crear el cluster
kind create cluster --name tienda

# 2. Construir y cargar las imágenes de la app
cd microservicios-k8s/app
docker build -t tienda/backend:latest  ./backend
docker build -t tienda/frontend:latest ./frontend
kind load docker-image tienda/backend:latest  --name tienda
kind load docker-image tienda/frontend:latest --name tienda
cd ..

# 3. Instalar el Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# 4. Aplicar todos los manifiestos (en orden)
kubectl apply -f 00-namespace.yaml
kubectl apply -f 01-configmap.yaml -f 02-secret.yaml
kubectl apply -f 03-db/ -f 04-backend/ -f 05-frontend/
kubectl apply -f 06-ingress.yaml -f 07-networkpolicy.yaml -f 08-rbac.yaml
kubectl apply -f 09-pdb.yaml -f 10-resourcequota.yaml

# 5. Probar
echo "127.0.0.1 tienda.local" | sudo tee -a /etc/hosts
curl http://tienda.local/
curl http://tienda.local/api/productos
```

### Opción B — minikube

```bash
minikube start --addons=ingress
eval $(minikube docker-env)            # para que kubectl use el daemon de minikube
# construir imágenes como arriba (sin kind load) y aplicar manifiestos igual
minikube ip                            # úsalo como host en /etc/hosts
```

### Validar sin cluster

El script `test.sh` valida los YAML de la carpeta `solucion/` sin necesidad de cluster:

```bash
bash microservicios-k8s/test.sh
# → OK Tests pasaron
```

## Solución

<details>
<summary>Mostrar solución</summary>

La carpeta [`microservicios-k8s/solucion/`](./microservicios-k8s/solucion/) contiene **todos los
manifiestos completos** (sin `# TODO`), listos para aplicar. Si te atascas en una fase, compara tu
archivo con el equivalente en `solucion/`.

Resumen de la solución:

- **Namespace** `tienda-online` con labels `app: tienda`.
- **ConfigMap** `tienda-config` con host/puerto de la BD, nombre de la BD, usuario y URLs.
- **Secret** `tienda-secrets` con `POSTGRES_PASSWORD`, `BACKEND_API_KEY` y `JWT_SECRET` (usando
  `stringData` para legibilidad).
- **StatefulSet** `postgres` (imagen `postgres:15-alpine`) con env desde ConfigMap/Secret,
  sondas `pg_isready`, y un PVC de 5 Gi enlazado a un PV estático.
- **Deployment** `backend` (Flask) con 2 réplicas, `resources`, sondas HTTP `/health` y `/ready`,
  y `envFrom` para cargar config y secretos.
- **HPA** `backend` entre 2 y 6 réplicas, escalando por CPU (60 %) y memoria (70 %).
- **Deployment** `frontend` (nginx) con 3 réplicas y sondas.
- **Ingress** `tienda-ingress` con host `tienda.local`, `/` → frontend y `/api` → backend.
- **NetworkPolicy**: `default-deny` + políticas por componente (frontend, backend, db).
- **RBAC**: ServiceAccount `tienda-sa`, Role de lectura y RoleBinding.
- **PDB** para backend (`minAvailable: 1`) y frontend (`minAvailable: 2`).
- **ResourceQuota** limitando CPU, memoria y número de objetos del namespace.

```bash
# Aplicar la solución completa de golpe:
kubectl apply -f microservicios-k8s/solucion/
```

</details>
