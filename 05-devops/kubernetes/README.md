# Kubernetes

> Ruta de aprendizaje completa de Kubernetes (K8s) en español: guías de estudio, ejercicios por niveles, proyectos integradores y proyecto final.

Kubernetes es el orquestador de contenedores más usado del mundo. Se encarga de desplegar, escalar y mantener aplicaciones en contenedores de forma automática, gestionando la alta disponibilidad, el autoescalado, las actualizaciones continuas y la recuperación ante fallos. Es la pieza central del DevOps moderno y un requisito para cualquier arquitectura de microservicios en producción.

Esta ruta asume que ya conoces **Docker** (contenedores, imágenes, Dockerfile) y **Linux** básico. Cada guía introduce la teoría con ejemplos de manifiestos YAML reales y enlaza a los ejercicios que la refuerzan.

## Estructura

```
kubernetes/
├── 01-fundamentos.md                 # Guía 01: arquitectura, kind/minikube, kubectl, pods
├── 02-pods-y-deployments.md          # Guía 02: pods, deployments, replicasets, rollouts
├── 03-servicios-y-configuracion.md  # Guía 03: services, configmaps, secrets, volumes
├── 04-almacenamiento-y-escalado.md   # Guía 04: PV/PVC, statefulsets, daemonsets, HPA
├── 05-produccion-y-networking.md     # Guía 05: ingress, RBAC, helm, GitOps, monitorización
├── ejercicios/
│   ├── README.md                      # Índice de los 30 ejercicios
│   ├── nivel-01-fundamentos/          # 6 ejercicios (1-6)
│   ├── nivel-02-basico/               # 6 ejercicios (7-12)
│   ├── nivel-03-intermedio/           # 6 ejercicios (13-18)
│   ├── nivel-04-avanzado/             # 6 ejercicios (19-24)
│   ├── nivel-05-experto/              # 6 ejercicios (25-30)
│   └── proyectos/
│       ├── README.md                  # Proyecto final de microservicios
│       └── microservicios-k8s/        # Starter con manifiestos base
└── README.md                          # este archivo
```

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Qué es K8s, orquestación, arquitectura del cluster, kind/minikube, kubectl, namespaces, YAML, pods |
| [02 — Pods y Deployments](02-pods-y-deployments.md) | Pods, multi-container, Deployments, ReplicaSets, labels, selectores, rolling updates, rollouts |
| [03 — Servicios y Configuración](03-servicios-y-configuracion.md) | Services (ClusterIP, NodePort, LoadBalancer), DNS, ConfigMaps, Secrets, volumes |
| [04 — Almacenamiento y Escalado](04-almacenamiento-y-escalado.md) | PV/PVC, StorageClasses, StatefulSets, DaemonSets, Jobs, HPA, VPA, recursos |
| [05 — Producción y Networking](05-produccion-y-networking.md) | Ingress, NetworkPolicies, RBAC, Helm, ArgoCD, Prometheus, Grafana, afinidad, PDB, quotas |

## Ejercicios por nivel

Cada ejercicio está en una carpeta con `README.md` (enunciado, requisitos, pistas y solución), manifiestos YAML (`*.yaml`), código de ejemplo (`app/`), solución (`solucion/`) y `test.sh` que valida los YAML con `python3`. Ejecuta los tests desde la carpeta del ejercicio con `bash test.sh`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Pod básico YAML, pod multi-container, deployment con réplicas, kubectl get/describe, namespace, labels y selectors |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Service ClusterIP, Service NodePort, ConfigMap, Secret, volumen emptyDir, rolling update y rollout undo |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | PersistentVolume y PVC, StatefulSet, DaemonSet, Job y CronJob, Ingress, probes liveness/readiness |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | HPA, NetworkPolicy, RBAC, Helm chart, resource requests/limits, deployment strategy |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | GitOps con Kustomize, deployment canary, Prometheus, deployment blue-green, affinity/taints, producción completa |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyecto final

[**Despliegue de microservicios en Kubernetes**](ejercicios/proyectos/README.md) — despliegue completo de 3 microservicios (frontend, backend, db) con deployments, services, ingress, configmaps, secrets, persistent volumes, HPA, probes, network policies y RBAC.

## Requisitos previos

- **Docker**: contenedores, imágenes, Dockerfile (ver [05-devops/docker/](../docker/))
- **Linux básico**: terminal, ficheros, permisos (ver [05-devops/linux/](../linux/))
- **Git**: control de versiones (ver [05-devops/git/](../git/))
- **YAML**: sintaxis básica (indentación, listas, mapas)
- **Conceptos de red**: puertos, DNS, HTTP

## Cómo ejecutar

- **Tests de los ejercicios** (sin dependencias): desde la carpeta de un ejercicio, `bash test.sh`. El test valida los manifiestos YAML con `python3` y, si hay un cluster K8s disponible (kind/minikube), los aplica y verifica.
- **Cluster local**: instala [kind](https://kind.sigs.k8s.io/) o [minikube](https://minikube.sigs.k8s.io/) y crea un cluster con `kind create cluster` o `minikube start`.
- **Proyecto final**: requiere un cluster local; aplica los manifiestos con `kubectl apply -f`.

## Recursos

- [Documentación oficial de Kubernetes](https://kubernetes.io/es/docs/home/)
- [Kubernetes Interactive Tutorial](https://kubernetes.io/es/docs/tutorials/)
- [kubectl Cheat Sheet](https://kubernetes.io/es/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Patterns](https://www.redhat.com/en/resources/oreilly-kubernetes-patterns-cloud-native-apps)
- [Awesome Kubernetes](https://github.com/ramitsurana/awesome-kubernetes)
