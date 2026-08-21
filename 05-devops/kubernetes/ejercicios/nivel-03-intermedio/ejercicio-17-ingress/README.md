# Ejercicio 17 - Ingress

- **Nivel:** 3/5
- **Tema:** Ingress con reglas de routing a 2 services
- **Tiempo estimado:** 30 min

## Enunciado

Un **Ingress** expone servicios HTTP/HTTPS desde fuera del cluster con un **solo punto de entrada**, enrutando el tráfico según el dominio (`host`) o la ruta (`path`) hacia distintos Services. No funciona solo: necesita un **Ingress Controller** (nginx-ingress, traefik, HAProxy) que lee los recursos Ingress y configura el proxy.

```
Internet → Ingress Controller → Ingress (routing por path)
                                   ├── /      → frontend-service → pods frontend
                                   └── /api   → backend-service  → pods backend
```

Debes crear una aplicación con frontend y backend accesibles por un mismo Ingress:

1. Un **Deployment** `frontend` con imagen `nginx:1.25` (2 réplicas) y label `app: frontend`.
2. Un **Service** `frontend-service` (ClusterIP, puerto 80 → 80) con selector `app: frontend`.
3. Un **Deployment** `backend` con imagen `nginx:1.25` (2 réplicas) y label `app: backend`.
4. Un **Service** `backend-service` (ClusterIP, puerto 80 → 80) con selector `app: backend`.
5. Un **Ingress** `app-ingress` que:
   - use `ingressClassName: nginx`
   - tenga una regla para el host `app.midominio.com`
   - enrute la ruta `/` (Prefix) al `frontend-service:80`
   - enrute la ruta `/api` (Prefix) al `backend-service:80`

## Requisitos

- [ ] Existe un Deployment `frontend` (2 réplicas) con label `app: frontend`.
- [ ] Existe un Service `frontend-service` que selecciona `app: frontend`.
- [ ] Existe un Deployment `backend` (2 réplicas) con label `app: backend`.
- [ ] Existe un Service `backend-service` que selecciona `app: backend`.
- [ ] Existe un Ingress `app-ingress` con `ingressClassName: nginx`.
- [ ] El Ingress define una regla para el host `app.midominio.com`.
- [ ] El Ingress enruta `/` → `frontend-service` y `/api` → `backend-service`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` de Ingress moderno es `networking.k8s.io/v1`.
- En la API v1, el backend se especifica como `backend.service.name` y `backend.service.port.number` (no `serviceName`/`servicePort` que era de versiones antiguas).
- `pathType: Prefix` enruta todo lo que empiece por ese path. `pathType: Exact` exige coincidencia exacta.
- `ingressClassName: nginx` indica qué Ingress Controller procesa este Ingress (necesitas tener el ingress-nginx instalado).
- Cada `path` dentro de `rules[].http.paths` tiene su propio `backend`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# frontend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  type: ClusterIP
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 80
```

```yaml
# backend.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  type: ClusterIP
  selector:
    app: backend
  ports:
    - port: 80
      targetPort: 80
```

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  ingressClassName: nginx
  rules:
    - host: app.midominio.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: backend-service
                port:
                  number: 80
```

</details>
