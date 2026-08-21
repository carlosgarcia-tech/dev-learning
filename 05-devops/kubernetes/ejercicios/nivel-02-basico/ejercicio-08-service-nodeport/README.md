# Ejercicio 08 - Service tipo NodePort

- **Nivel:** 2/5
- **Tema:** Services (NodePort) para exponer un Deployment en un puerto del nodo
- **Tiempo estimado:** 20 min

## Enunciado

Crea un **Deployment** con 3 réplicas de `nginx` y un **Service** de tipo `NodePort`
que exponga ese Deployment en un puerto fijo de los nodos del cluster.

Un `NodePort` abre un puerto (por defecto entre 30000 y 32767) en **todos los nodos**
del cluster y redirige el tráfico a los pods seleccionados. Es útil para pruebas
locales y para exponer servicios sin un balanceador externo.

## Requisitos

- [ ] Un Deployment `web` con 3 réplicas de `nginx` (puerto 80).
- [ ] Un Service `web` de tipo `NodePort` con `selector` que coincida con los pods.
- [ ] El Service expone el puerto 80 (`port`), apunta al `targetPort` 80 y define un
      `nodePort` fijo en el rango 30000-32767.
- [ ] El `selector` del Service coincide con las `labels` de los pods del Deployment.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El tipo de Service se declara con `spec.type: NodePort`.
- El rango válido de `nodePort` es 30000-32767. Si no lo defines, K8s asigna uno
  aleatorio dentro del rango.
- `port` es el puerto del Service (interno); `targetPort` el del contenedor; `nodePort`
  el del nodo.
- Para probarlo en un cluster local:
  ```bash
  kubectl apply -f deployment.yaml -f service.yaml
  kubectl get svc web
  # minikube:
  minikube service web --url
  # kind: el NodePort se expone en el puerto del nodo del contenedor Docker
  kubectl get nodes -o wide
  curl http://<NODE_IP>:30080
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
  type: NodePort
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 30080
      name: http
```

</details>
