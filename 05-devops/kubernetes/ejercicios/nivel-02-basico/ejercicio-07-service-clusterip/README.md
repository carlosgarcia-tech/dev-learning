# Ejercicio 07 - Service tipo ClusterIP

- **Nivel:** 2/5
- **Tema:** Services (ClusterIP) para exponer un Deployment dentro del cluster
- **Tiempo estimado:** 20 min

## Enunciado

Crea un **Deployment** con 3 réplicas de `nginx` y un **Service** de tipo `ClusterIP`
que exponga ese Deployment dentro del cluster en el puerto 80.

Un `ClusterIP` es el tipo de Service por defecto: expone el servicio en una IP interna
del cluster, accesible **solo desde dentro del cluster**. Es la base para que los pods
se comuniquen entre sí mediante un nombre DNS estable.

## Requisitos

- [ ] Un Deployment `web` con 3 réplicas de `nginx` (puerto 80).
- [ ] Un Service `web` de tipo `ClusterIP` con `selector` que coincida con los pods.
- [ ] El Service expone el puerto 80 y apunta al `targetPort` 80.
- [ ] El `selector` del Service coincide con las `labels` de los pods del Deployment.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` de un Service es `v1` y el `kind` es `Service`.
- `type: ClusterIP` es el valor por defecto, pero conviene declararlo explícitamente.
- El `selector` del Service debe usar las mismas labels que `template.metadata.labels`
  del Deployment (p. ej. `app: web`).
- `port` es el puerto del Service; `targetPort` es el puerto del contenedor.
- Para probarlo en un cluster real:
  ```bash
  kubectl apply -f deployment.yaml -f service.yaml
  kubectl get svc web
  # Desde dentro del cluster:
  kubectl run tmp --image=busybox:1.36 --rm -it --restart=Never -- wget -qO- http://web
  ```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  labels:
    app: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
  labels:
    app: web
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
```

</details>
