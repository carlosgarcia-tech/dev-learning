# Ejercicio 20 - NetworkPolicy

- **Nivel:** 4/5
- **Tema:** Aislamiento de tráfico entre pods con NetworkPolicy
- **Tiempo estimado:** 25 min

## Enunciado

Tienes un escenario con un **frontend** y un **backend**. Crea una **NetworkPolicy** que
asegure que **solo el frontend pueda llamar al backend**, bloqueando el resto del tráfico
entrante hacia el backend.

Necesitas:
- Un Deployment y Service `frontend` (etiqueta `app: frontend`).
- Un Deployment y Service `backend` (etiqueta `app: backend`).
- Una NetworkPolicy `backend-policy` que:
  - Seleccione los pods del backend (`podSelector` con `app: backend`).
  - Permita el tráfico entrante (`ingress`) **solo** desde pods con etiqueta `app: frontend`.
  - En el puerto del backend (por ejemplo `8080`).

Al aplicar la política, el backend queda aislado: el resto de pods del namespace no
podrán alcanzarlo, pero el frontend sí.

## Requisitos

- [ ] Deployment + Service `frontend`.
- [ ] Deployment + Service `backend`.
- [ ] NetworkPolicy que seleccione el backend.
- [ ] La NetworkPolicy solo permite ingress desde pods `app: frontend`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `apiVersion` de NetworkPolicy: `networking.k8s.io/v1`.
- El `podSelector` del nivel raíz de la política define a qué pods se aplica el aislamiento.
- Dentro de `ingress`, `from` con `podSelector` restringe qué pods pueden conectarse.
- El `namespaceSelector` es **opcional**: si lo omites y usas solo `podSelector`, se
  interpreta dentro del mismo namespace.
- Recuerda exponer el puerto correcto en `ports`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`frontend.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: frontend
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
  name: frontend
spec:
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 80
```

`backend.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
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
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - port: 8080
      targetPort: 8080
```

`networkpolicy.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
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

</details>
