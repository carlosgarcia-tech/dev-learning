# 05 — Producción y Networking

## Objetivos

- [ ] Entender **Ingress** y los **Ingress Controllers** para exponer HTTP/HTTPS.
- [ ] Crear **NetworkPolicies** para restringir el tráfico entre pods.
- [ ] Gestionar acceso con **RBAC**: Roles, RoleBindings, ClusterRoles, ServiceAccounts.
- [ ] Usar **Helm** para empaquetar y desplegar aplicaciones.
- [ ] Gestionar secretos externos con **External Secrets**.
- [ ] Desplegar con **ArgoCD** (GitOps).
- [ ] Monitorizar con **Prometheus** y **Grafana**.
- [ ] Recoger logs con **Fluentd**.
- [ ] Controlar la colocación de pods con **nodeSelector**, **affinity**, **anti-affinity**, **taints** y **tolerations**.
- [ ] Configurar **Pod Security** (admission, PSA).
- [ ] Proteger disponibilidad con **PodDisruptionBudget (PDB)**.
- [ ] Limitar recursos con **LimitRanges** y **ResourceQuotas**.
- [ ] Hacer **troubleshooting** avanzado: `logs`, `exec`, `port-forward`, `debug`.

## Apuntes

### Ingress e Ingress Controller

Un **Ingress** expone servicios HTTP y HTTPS desde fuera del cluster con un solo punto de entrada, soportando **dominios, rutas y TLS**. No funciona solo: necesita un **Ingress Controller** (nginx-ingress, traefik, HAProxy) que lee los recursos Ingress y configura un proxy.

```
Internet → Ingress Controller (LoadBalancer) → Ingress → Services → Pods
```

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mi-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.midominio.com
      secretName: tls-secret
  rules:
    - host: api.midominio.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 80
          - path: /docs
            pathType: Prefix
            backend:
              service:
                name: docs-service
                port:
                  number: 80
```

```bash
# En minikube, habilitar el ingress controller:
minikube addons enable ingress

# Aplicar el ingress
kubectl apply -f ingress.yaml
kubectl get ingress
# NAME         CLASS   HOSTS                ADDRESS        PORTS     AGE
# mi-ingress   nginx   api.midominio.com    192.168.49.2   80, 443   1m
```

> En local, para resolver `api.midominio.com` al cluster, añade a `/etc/hosts`: `192.168.49.2 api.midominio.com` (la IP que da `minikube ip`).

### NetworkPolicies

Por defecto, **todos los pods pueden comunicarse con todos los pods** en un cluster K8s. Las **NetworkPolicies** restringen el tráfico entre pods. Requieren un CNI que las soporte (Calico, Cilium, Weave).

```yaml
# networkpolicy.yaml — solo el frontend puede llamar al backend
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: produccion
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

| Campo | Descripción |
|---|---|
| `podSelector` | A qué pods aplica la policy |
| `policyTypes` | `Ingress`, `Egress` o ambos |
| `ingress.from` | Quién puede entrar (por pod selector, namespace selector o IP) |
| `egress.to` | A quién puede llamar |
| `egress.ports` | A qué puertos |

> Una NetworkPolicy es **deny por defecto** para los pods seleccionados: una vez aplicada, solo el tráfico explícitamente permitido pasa. El resto se bloquea.

### RBAC: Roles, RoleBindings, ClusterRoles, ServiceAccounts

**RBAC** (Role-Based Access Control) controla qué usuarios y ServiceAccounts pueden hacer qué operaciones sobre qué recursos.

| Recurso | Ámbito | Uso |
|---|---|---|
| **Role** | Un namespace | Permisos dentro de un namespace |
| **RoleBinding** | Un namespace | Asigna un Role a un usuario/ServiceAccount |
| **ClusterRole** | Todo el cluster | Permisos globales o en todos los namespaces |
| **ClusterRoleBinding** | Todo el cluster | Asigna un ClusterRole a un usuario/ServiceAccount |

#### ServiceAccount

Un **ServiceAccount** es una identidad para procesos que corren en pods (no para humanos).

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-sa
  namespace: produccion
```

#### Role y RoleBinding

```yaml
# role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: produccion
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: api-pod-reader
  namespace: produccion
subjects:
  - kind: ServiceAccount
    name: api-sa
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

| Verb | Significado |
|---|---|
| `get` | Ver un recurso concreto |
| `list` | Listar recursos |
| `watch` | Observar cambios |
| `create` | Crear |
| `update`, `patch` | Modificar |
| `delete` | Borrar |
| `*` | Todos los verbs |

```bash
# Verificar permisos
kubectl auth can-i get pods --as=system:serviceaccount:produccion:api-sa -n produccion
# yes

kubectl auth can-i delete pods --as=system:serviceaccount:produccion:api-sa -n produccion
# no
```

### Helm charts

**Helm** es el gestor de paquetes de Kubernetes. Un **chart** es un paquete que define plantillas YAML parametrizables. Permite instalar aplicaciones complejas con un solo comando.

```bash
# Instalar Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Añadir un repositorio
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Buscar un chart
helm search repo nginx

# Instalar un chart
helm install mi-nginx bitnami/nginx --set service.type=NodePort

# Ver releases
helm list

# Actualizar valores
helm upgrade mi-nginx bitnami/nginx --set replicaCount=3

# Desinstalar
helm uninstall mi-nginx
```

#### Crear un chart

```bash
helm create mi-chart
```

Estructura:

```
mi-chart/
├── Chart.yaml          # metadatos del chart
├── values.yaml         # valores por defecto
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── _helpers.tpl
```

```yaml
# Chart.yaml
apiVersion: v2
name: mi-chart
description: Mi aplicación
version: 0.1.0
appVersion: "1.0"
```

```yaml
# values.yaml
replicaCount: 2
image:
  repository: nginx
  tag: "1.25"
service:
  type: ClusterIP
  port: 80
```

```yaml
# templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
        - name: app
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: {{ .Values.service.port }}
```

### External Secrets

Los Secrets de K8s son base64, no cifrados. **External Secrets Operator** sincroniza secretos desde un gestor externo (AWS Secrets Manager, Vault, GCP Secret Manager) hacia Secrets de K8s.

```yaml
# SecretStore: conexión al gestor externo
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-store
spec:
  provider:
    vault:
      server: "https://vault.midominio.com"
      path: "secret"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "external-secrets"
---
# ExternalSecret: define qué secretos sincronizar
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-external-secret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-store
    kind: SecretStore
  target:
    name: db-secret          # nombre del Secret de K8s que se creará
  data:
    - secretKey: password
      remoteRef:
        key: prod/db/password
        property: value
```

### Despliegue con ArgoCD (GitOps)

**ArgoCD** es una herramienta de **GitOps**: sincroniza el estado del cluster con un repositorio Git. El repositorio es la fuente de verdad; ArgoCD detecta cambios y los aplica automáticamente.

```
Git repo (manifiestos) → ArgoCD → Cluster K8s
```

```bash
# Instalar ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Obtener la contraseña inicial
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port-forward para acceder a la UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
# → https://localhost:8080
```

```yaml
# application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mi-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/mi-org/mi-repo
    targetRevision: main
    path: manifests/
  destination:
    server: https://kubernetes.default.svc
    namespace: produccion
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### Monitorización con Prometheus y Grafana

**Prometheus** recolecta métricas; **Grafana** las visualiza en dashboards. Se instalan juntos con Helm o el kube-prometheus-stack.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Acceder a Grafana
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
# Usuario: admin  Contraseña: prom-operator
```

Para exponer métricas de tu app, defines un **ServiceMonitor**:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: api-monitor
  labels:
    release: monitoring
spec:
  selector:
    matchLabels:
      app: api
  endpoints:
    - port: http
      path: /metrics
      interval: 30s
```

Tu app debe exponer métricas en `/metrics` en formato Prometheus (con `prometheus-client` en Python, `prometheus-middleware` en Rust, etc.).

### Logging con Fluentd

**Fluentd** (o Fluent Bit) recolecta logs de los pods y los envía a un backend (Elasticsearch, Loki, S3). Suele desplegarse como DaemonSet en cada nodo.

```yaml
# Fluentd lee los logs de /var/log/containers/ del nodo
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
        - name: fluentd
          image: fluent/fluentd-kubernetes-daemonset:v1.16
          env:
            - name: FLUENT_ELASTICSEARCH_HOST
              value: "elasticsearch.logging"
          volumeMounts:
            - name: varlog
              mountPath: /var/log
            - name: varlibdockercontainers
              mountPath: /var/lib/docker/containers
              readOnly: true
      volumes:
        - name: varlog
          hostPath:
            path: /var/log
        - name: varlibdockercontainers
          hostPath:
            path: /var/lib/docker/containers
```

### Afinidad de nodos

Controla en qué nodos se colocan los pods.

#### nodeSelector (simple)

```yaml
spec:
  nodeSelector:
    disktype: ssd          # solo nodos con la label disktype=ssd
```

#### nodeAffinity (avanzado)

```yaml
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: disktype
                operator: In
                values: [ssd, nvme]
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 10
          preference:
            matchExpressions:
              - key: zone
                operator: In
                values: [us-east-1a]
```

#### podAffinity y podAntiAffinity

Colocar pods cerca o lejos de otros pods.

```yaml
spec:
  affinity:
    podAntiAffinity:                  # ANTI-AFINIDAD: que NO estén juntos
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app: api
          topologyKey: kubernetes.io/hostname   # en nodos distintos
```

Esto asegura que cada réplica del Deployment esté en un nodo distinto (alta disponibilidad).

### Taints y tolerations

Los **taints** "marcan" un nodo como rechazado para ciertos pods. Las **tolerations** permiten a un pod tolerar un taint.

```bash
# Marcar un nodo para solo jobs batch
kubectl taint nodes node-1 workload=batch:NoSchedule
```

```yaml
spec:
  tolerations:
    - key: "workload"
      operator: "Equal"
      value: "batch"
      effect: "NoSchedule"
```

| Effect | Significado |
|---|---|
| `NoSchedule` | No programa pods nuevos que no toleren el taint |
| `PreferNoSchedule` | Intenta no programar, pero no es estricto |
| `NoExecute` | Expulsa los pods actuales que no lo toleren |

### Pod Security

La **Pod Security Admission** (PSA) aplica estándares de seguridad a nivel de namespace: `privileged`, `baseline`, `restricted`.

```yaml
# Marcar un namespace como restricted
apiVersion: v1
kind: Namespace
metadata:
  name: produccion
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

| Nivel | Restricciones |
|---|---|
| `privileged` | Sin restricciones (inseguro) |
| `baseline` | Bloquea escaladas de privilegios peligrosas |
| `restricted` | Solo pods hardening total: no root, drop capabilities, readOnlyRootFilesystem |

### PodDisruptionBudget (PDB)

Un **PDB** garantiza que un mínimo de pods estén siempre disponibles durante **interrupciones voluntarias** (drain de un nodo, actualización del cluster).

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  minAvailable: 2              # al menos 2 pods siempre disponibles
  selector:
    matchLabels:
      app: api
```

O usando porcentaje:

```yaml
spec:
  maxUnavailable: 25%         # como mucho el 25% pueden estar no disponibles
```

### LimitRanges y ResourceQuotas

#### LimitRange

Define defaults y límites por contenedor en un namespace.

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
spec:
  limits:
    - default:                  # limit por defecto
        cpu: "500m"
        memory: "512Mi"
      defaultRequest:           # request por defecto
        cpu: "100m"
        memory: "128Mi"
      type: Container
```

#### ResourceQuota

Limita el total de recursos consumidos por un namespace.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: prod-quota
spec:
  hard:
    requests.cpu: "4"
    requests.memory: "8Gi"
    limits.cpu: "8"
    limits.memory: "16Gi"
    pods: "20"
    services: "10"
    persistentvolumeclaims: "5"
```

### Troubleshooting

#### kubectl logs

```bash
kubectl logs <pod>                      # logs del contenedor principal
kubectl logs -f <pod>                   # sigue los logs
kubectl logs <pod> -c <contenedor>      # logs de un contenedor concreto
kubectl logs --previous <pod>           # logs del contenedor anterior (antes del crash)
kubectl logs <pod> --tail=50           # últimas 50 líneas
```

#### kubectl exec

```bash
kubectl exec -it <pod> -- sh           # entrar al pod
kubectl exec -it <pod> -- env          # ver variables de entorno
kubectl exec -it <pod> -- cat /etc/config/LOG_LEVEL   # ver un fichero
```

#### kubectl port-forward

Redirige un puerto local al pod, sin necesidad de Service o Ingress. Útil para depurar.

```bash
kubectl port-forward <pod> 8080:80      # localhost:8080 → pod:8080
kubectl port-forward svc/api-service 5432:5432  # a un service
```

#### kubectl debug

`kubectl debug` inyecta un contenedor efímero en un pod para depurarlo (útil si la imagen no tiene shell).

```bash
kubectl debug -it <pod> --image=busybox --target=<contenedor>
```

#### Diagnóstico paso a paso

```bash
# 1. ¿El pod está corriendo?
kubectl get pods
kubectl describe pod <pod>          # mira Events al final

# 2. ¿Qué dicen los logs?
kubectl logs <pod>
kubectl logs --previous <pod>       # si ha crasheado

# 3. ¿La imagen existe?
kubectl describe pod <pod> | grep -A5 Events

# 4. ¿El service tiene endpoints?
kubectl get endpoints <service>

# 5. ¿Llega el tráfico?
kubectl exec -it <pod> -- curl http://api-service:80

# 6. Eventos del namespace
kubectl get events --sort-by=.lastTimestamp
```

### Conceptos clave

| Concepto | Definición |
|---|---|
| **Ingress** | Recurso que expone HTTP/HTTPS con dominios, rutas y TLS |
| **Ingress Controller** | El pod que implementa Ingress (nginx, traefik) |
| **NetworkPolicy** | Restringe el tráfico entre pods |
| **RBAC** | Control de acceso basado en roles |
| **ServiceAccount** | Identidad para procesos en pods |
| **Helm** | Gestor de paquetes de K8s (charts) |
| **GitOps** | El repo Git es la fuente de verdad; ArgoCD sincroniza |
| **Prometheus** | Sistema de recolección de métricas |
| **Grafana** | Visualización de métricas en dashboards |
| **Fluentd** | Recolector de logs |
| **nodeSelector** | Restricción simple de nodo por labels |
| **affinity/anti-affinity** | Colocar pods cerca o lejos de otros |
| **taint/toleration** | Marcar nodos y permitir que ciertos pods los toleren |
| **PDB** | Garantiza pods disponibles durante interrupciones |
| **ResourceQuota** | Limita recursos totales por namespace |
| **LimitRange** | Define defaults y límites por contenedor |

## Errores comunes

- **Ingress que no enruta** → falta el Ingress Controller o `ingressClassName` no coincide. Verifica `kubectl get ingressclass`.

- **NetworkPolicy que bloquea todo** → una vez aplicada una policy de ingress a un pod, **todo** el tráfico no explícitamente permitido se bloquea. Si tu app deja de responder, revisa las policies.

- **ServiceAccount sin permisos** → el pod no puede leer configmaps, listas pods, etc. Verifica con `kubectl auth can-i --as=system:serviceaccount:<ns>:<sa>`.

- **Confundir Role y ClusterRole** → Role es para un namespace; ClusterRole es global. Usa Role+RoleBinding para acceso a un namespace; ClusterRole+ClusterRoleBinding para acceso global.

- **Secrets en Helm values.yaml en texto plano** → los values pueden acabar en Git. Usa `--set` en CI o External Secrets.

- **No usar PDB en producción** → durante un drain de nodo, K8s puede tirar todos tus pods a la vez. Un PDB garantiza que siempre haya un mínimo disponible.

- **Olvidar `resources.requests`** → sin requests, el HPA no funciona y el scheduler no coloca bien los pods.

- **Pensar que Ingress es un LoadBalancer** → Ingress es solo una regla. Necesita un Ingress Controller que lea esas reglas y configure el proxy.

- **Affinity demasiado estricta** → si pides `requiredDuringScheduling` con condiciones que ningún nodo cumple, el pod queda `Pending` para siempre.

- **Taints sin tolerations** → si taintas un nodo y ningún pod lo tolera, queda vacío. Útil para nodos dedicados, pero revisa que los pods que quieres ahí tengan la toleration.

## Recursos

- [Kubernetes — Ingress](https://kubernetes.io/es/docs/concepts/services-networking/ingress/)
- [Kubernetes — NetworkPolicies](https://kubernetes.io/es/docs/concepts/services-networking/network-policies/)
- [Kubernetes — RBAC](https://kubernetes.io/es/docs/reference/access-authn-authz/rbac/)
- [Helm — Docs](https://helm.sh/es/docs/)
- [ArgoCD — Docs](https://argo-cd.readthedocs.io/)
- [Prometheus — Docs](https://prometheus.io/docs/introduction/overview/)
- [Kubernetes — Taints and Tolerations](https://kubernetes.io/es/docs/concepts/scheduling-eviction/taint-and-toleration/)
- [Kubernetes — Assigning Pods to Nodes](https://kubernetes.io/es/docs/concepts/scheduling-eviction/assign-pod-node/)
