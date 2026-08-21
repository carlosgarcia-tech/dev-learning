# Ejercicio 30 - Producción completa

- **Nivel:** 5/5
- **Tema:** Despliegue de producción con todos los recursos
- **Tiempo estimado:** 45 min

## Enunciado

Este ejercicio integra todos los recursos necesarios para un despliegue de producción
real: un Deployment con recursos y probes, un Service, un Ingress para exponerlo al
exterior, un **HPA** para escalado automático, un **PDB** (PodDisruptionBudget) para
evitar downtime en mantenimientos, y un **ResourceQuota** para limitar el consumo del
namespace.

Crea los siguientes recursos:
1. **Deployment** con 3 réplicas, liveness/readiness probes y requests/limits.
2. **Service** ClusterIP que expone el puerto 80.
3. **Ingress** que enruta `api.example.com` al Service.
4. **HPA** que escala entre 2 y 10 réplicas al 70% de CPU.
5. **PDB** que garantiza que al menos 2 pods estén disponibles.
6. **ResourceQuota** que limita CPU (2 cores) y memoria (2Gi) del namespace.

> Este es el "checklist de producción" mínimo en Kubernetes.

## Requisitos

- [ ] Deployment con 3 réplicas, livenessProbe, readinessProbe, requests y limits.
- [ ] Service ClusterIP en puerto 80.
- [ ] Ingress con host `api.example.com` apuntando al Service.
- [ ] HPA con minReplicas=2, maxReplicas=10 y CPU al 70%.
- [ ] PDB con minAvailable=2.
- [ ] ResourceQuota con límites de CPU (2) y memoria (2Gi).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El Ingress requiere un controlador (nginx-ingress, traefik...) instalado en el cluster.
- `apiVersion` del Ingress: `networking.k8s.io/v1`.
- `apiVersion` del HPA: `autoscaling/v2`.
- `apiVersion` del PDB: `policy/v1`.
- El HPA referencia el Deployment por `scaleTargetRef.name` y usa
  `metrics[].resource.target.averageUtilization`.
- El PDB usa `selector.matchLabels` para seleccionar los pods del Deployment.
- El ResourceQuota define `hard` con `requests.cpu`, `requests.memory`, `limits.cpu`,
  `limits.memory`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  labels:
    app: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 200m
              memory: 256Mi
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  type: ClusterIP
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 80
```

`ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api
                port:
                  number: 80
```

`hpa.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

`pdb.yaml`:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api
```

`resourcequota.yaml`:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 2Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

</details>
