# Ejercicios de Kubernetes — Índice

30 ejercicios progresivos (6 por nivel) + 1 proyecto final. Cada ejercicio contiene:

- `README.md` — enunciado, requisitos, pistas y solución (plegable)
- Manifiestos YAML (`*.yaml`) — los recursos a crear
- `app/` — código de ejemplo cuando aplica
- `solucion/` — los manifiestos YAML completos con la solución
- `test.sh` — valida los YAML con `python3` y, si hay cluster K8s, los aplica y verifica

## Cómo ejecutar los tests

Desde la carpeta del ejercicio:

```bash
bash test.sh
```

> **Nota:** `test.sh` valida todos los manifiestos YAML con `python3 yaml.safe_load`
> (no requiere dependencias externas). Si `kubectl` está disponible y hay un cluster
> (kind/minikube), aplica los manifiestos y verifica el estado. Sin cluster, solo
> valida la sintaxis y estructura de los YAML.

El script imprime `OK Tests pasaron` (salida `0`) o `FAIL Tests fallaron` (salida `1`).

## Nivel 01 — Fundamentos (1/5)

Pod básico en YAML, pod multi-container, deployment con réplicas, kubectl get/describe, namespace, labels y selectors.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Pod básico en YAML | [`nivel-01-fundamentos/ejercicio-01-pod-basico`](./nivel-01-fundamentos/ejercicio-01-pod-basico/) |
| 02 | Pod multi-container | [`nivel-01-fundamentos/ejercicio-02-pod-multi-container`](./nivel-01-fundamentos/ejercicio-02-pod-multi-container/) |
| 03 | Deployment con réplicas | [`nivel-01-fundamentos/ejercicio-03-deployment-replicas`](./nivel-01-fundamentos/ejercicio-03-deployment-replicas/) |
| 04 | kubectl get y describe | [`nivel-01-fundamentos/ejercicio-04-kubectl-get-describe`](./nivel-01-fundamentos/ejercicio-04-kubectl-get-describe/) |
| 05 | Namespace | [`nivel-01-fundamentos/ejercicio-05-namespace`](./nivel-01-fundamentos/ejercicio-05-namespace/) |
| 06 | Labels y selectors | [`nivel-01-fundamentos/ejercicio-06-labels-selectors`](./nivel-01-fundamentos/ejercicio-06-labels-selectors/) |

## Nivel 02 — Básico (2/5)

Service ClusterIP, service NodePort, configmap, secret, volumen emptyDir, rolling update y rollout undo.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 07 | Service ClusterIP | [`nivel-02-basico/ejercicio-07-service-clusterip`](./nivel-02-basico/ejercicio-07-service-clusterip/) |
| 08 | Service NodePort | [`nivel-02-basico/ejercicio-08-service-nodeport`](./nivel-02-basico/ejercicio-08-service-nodeport/) |
| 09 | ConfigMap | [`nivel-02-basico/ejercicio-09-configmap`](./nivel-02-basico/ejercicio-09-configmap/) |
| 10 | Secret | [`nivel-02-basico/ejercicio-10-secret`](./nivel-02-basico/ejercicio-10-secret/) |
| 11 | Volumen emptyDir | [`nivel-02-basico/ejercicio-11-volumen-emptydir`](./nivel-02-basico/ejercicio-11-volumen-emptydir/) |
| 12 | Rolling update y rollout undo | [`nivel-02-basico/ejercicio-12-rolling-update`](./nivel-02-basico/ejercicio-12-rolling-update/) |

## Nivel 03 — Intermedio (3/5)

PersistentVolume y PVC, statefulset, daemonset, job y cronjob, ingress, probes liveness/readiness.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 13 | PersistentVolume y PVC | [`nivel-03-intermedio/ejercicio-13-pv-pvc`](./nivel-03-intermedio/ejercicio-13-pv-pvc/) |
| 14 | StatefulSet | [`nivel-03-intermedio/ejercicio-14-statefulset`](./nivel-03-intermedio/ejercicio-14-statefulset/) |
| 15 | DaemonSet | [`nivel-03-intermedio/ejercicio-15-daemonset`](./nivel-03-intermedio/ejercicio-15-daemonset/) |
| 16 | Job y CronJob | [`nivel-03-intermedio/ejercicio-16-job-cronjob`](./nivel-03-intermedio/ejercicio-16-job-cronjob/) |
| 17 | Ingress | [`nivel-03-intermedio/ejercicio-17-ingress`](./nivel-03-intermedio/ejercicio-17-ingress/) |
| 18 | Probes liveness y readiness | [`nivel-03-intermedio/ejercicio-18-probes`](./nivel-03-intermedio/ejercicio-18-probes/) |

## Nivel 04 — Avanzado (4/5)

HPA horizontal pod autoscaler, networkpolicy, RBAC role y rolebinding, helm chart básico, resource requests limits, deployment strategy.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 19 | Horizontal Pod Autoscaler | [`nivel-04-avanzado/ejercicio-19-hpa`](./nivel-04-avanzado/ejercicio-19-hpa/) |
| 20 | NetworkPolicy | [`nivel-04-avanzado/ejercicio-20-networkpolicy`](./nivel-04-avanzado/ejercicio-20-networkpolicy/) |
| 21 | RBAC role y rolebinding | [`nivel-04-avanzado/ejercicio-21-rbac`](./nivel-04-avanzado/ejercicio-21-rbac/) |
| 22 | Helm chart básico | [`nivel-04-avanzado/ejercicio-22-helm-chart`](./nivel-04-avanzado/ejercicio-22-helm-chart/) |
| 23 | Resource requests y limits | [`nivel-04-avanzado/ejercicio-23-resource-requests-limits`](./nivel-04-avanzado/ejercicio-23-resource-requests-limits/) |
| 24 | Deployment strategy | [`nivel-04-avanzado/ejercicio-24-deployment-strategy`](./nivel-04-avanzado/ejercicio-24-deployment-strategy/) |

## Nivel 05 — Experto (5/5)

GitOps con kustomize, deployment canary, monitorización con prometheus, deployment blue-green, affinity anti-affinity y taints tolerations, producción completa.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 25 | GitOps con Kustomize | [`nivel-05-experto/ejercicio-25-gitops-kustomize`](./nivel-05-experto/ejercicio-25-gitops-kustomize/) |
| 26 | Deployment canary | [`nivel-05-experto/ejercicio-26-deployment-canary`](./nivel-05-experto/ejercicio-26-deployment-canary/) |
| 27 | Monitorización con Prometheus | [`nivel-05-experto/ejercicio-27-prometheus`](./nivel-05-experto/ejercicio-27-prometheus/) |
| 28 | Deployment blue-green | [`nivel-05-experto/ejercicio-28-deployment-blue-green`](./nivel-05-experto/ejercicio-28-deployment-blue-green/) |
| 29 | Affinity, anti-affinity y taints | [`nivel-05-experto/ejercicio-29-affinity-taints`](./nivel-05-experto/ejercicio-29-affinity-taints/) |
| 30 | Producción completa | [`nivel-05-experto/ejercicio-30-produccion-completa`](./nivel-05-experto/ejercicio-30-produccion-completa/) |

## Proyecto final

[**Despliegue de microservicios en Kubernetes**](proyectos/README.md) — despliegue completo de 3 microservicios (frontend, backend, db) con deployments, services, ingress, configmaps, secrets, persistent volumes, HPA, probes, network policies y RBAC.
