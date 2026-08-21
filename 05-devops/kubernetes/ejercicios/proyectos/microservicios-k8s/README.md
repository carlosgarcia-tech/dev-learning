# Proyecto Final — Archivos starter

Carpeta con los **archivos de partida incompletos** del proyecto final
*Despliegue de microservicios en Kubernetes*. El objetivo es completar los
manifiestos marcados con comentarios `# TODO: ...` y aplicarlos en un cluster.

> La descripción completa del proyecto, las fases y los criterios de aceptación
> están en el [`README.md` del proyecto](../README.md).

## Estructura

```
microservicios-k8s/
├── 00-namespace.yaml            # Namespace del proyecto
├── 01-configmap.yaml            # ConfigMap con la configuración
├── 02-secret.yaml               # Secret con contraseñas
├── 03-db/                       # Microservicio base de datos
│   ├── statefulset.yaml         #   StatefulSet de postgres (con TODOs)
│   ├── service.yaml             #   Headless service
│   └── pv-pvc.yaml              #   PersistentVolume y PVC
├── 04-backend/                  # Microservicio backend
│   ├── deployment.yaml          #   Deployment del backend (con TODOs)
│   ├── service.yaml             #   ClusterIP service
│   ├── hpa.yaml                 #   Horizontal Pod Autoscaler
│   └── probes-config.yaml       #   ConfigMap para las sondas
├── 05-frontend/                 # Microservicio frontend
│   ├── deployment.yaml          #   Deployment del frontend (con TODOs)
│   └── service.yaml             #   ClusterIP service
├── 06-ingress.yaml              # Ingress: / → frontend, /api → backend
├── 07-networkpolicy.yaml        # NetworkPolicy: frontend → backend → db
├── 08-rbac.yaml                 # ServiceAccount, Role, RoleBinding
├── 09-pdb.yaml                  # PodDisruptionBudget
├── 10-resourcequota.yaml        # ResourceQuota del namespace
├── app/                         # Código de ejemplo de los microservicios
│   ├── backend/                 #   Backend Python/Flask + Dockerfile
│   └── frontend/                #   Frontend nginx (HTML) + Dockerfile
├── solucion/                    # Solución completa (sin TODOs)
└── test.sh                      # Valida los YAML de solucion/
```

## Cómo trabajar

1. **Lee** el [`README.md` del proyecto](../README.md) para entender el contexto y las fases.
2. **Completa** los `# TODO` de cada manifiesto en orden (de `00` a `10`).
3. **Aplica** cada archivo con `kubectl apply -f <archivo>` y verifica con `kubectl get`.
4. **Construye** las imágenes de `app/` y cárgalas en tu cluster (kind/minikube).
5. **Verifica** con `bash test.sh` (valida los YAML de `solucion/`).

## Convenciones

- Namespace: `tienda-online`
- Labels comunes: `app: tienda`, `component: frontend|backend|db`, `version: v1`
- Imágenes (a construir desde `app/`): `tienda/backend:latest`, `tienda/frontend:latest`
- Puerto del backend: `5000` · Puerto del frontend: `80` · Puerto de postgres: `5432`

## Pistas

<details>
<summary>Mostrar pistas generales</summary>

- Los `# TODO` indican exactamente qué debes completar; no borres el resto del manifiesto.
- Un **headless service** (`clusterIP: None`) es necesario para que el StatefulSet dé a cada pod
  un DNS estable (`postgres-0.postgres.tienda-online.svc.cluster.local`).
- Para que el **HPA** funcione, el Deployment debe definir `resources.requests.cpu`.
- El **Ingress** necesita un ingress controller instalado (nginx-ingress en kind/minikube).
- Las **NetworkPolicies** requieren un CNI que las soporte (kind, minikube con Calico, etc.).
- Si un PVC queda `Pending`, comprueba el `storageClassName` (en kind suele ser `standard`).

</details>

## Tests

```bash
bash test.sh
# → OK Tests pasaron
```

El script valida con `python3 yaml.safe_load` que todos los YAML de `solucion/` sean
sintácticamente correctos y tengan los campos `apiVersion`, `kind` y `metadata.name`.
