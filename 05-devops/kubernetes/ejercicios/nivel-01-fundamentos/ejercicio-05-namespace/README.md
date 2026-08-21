# Ejercicio 05 - Namespace y recursos dentro de él

- **Nivel:** 1/5
- **Tema:** Namespaces para aislar recursos
- **Tiempo estimado:** 20 min

## Enunciado

Crea un manifiesto YAML (puede ser un único archivo con varios documentos separados por `---`) que defina:

1. Un **Namespace** llamado `demo-ns`.
2. Un **Deployment** dentro de ese namespace:
   - Nombre: `nginx-deploy`.
   - Imagen: `nginx:alpine`.
   - Réplicas: `2`.
   - Labels del Pod: `app: nginx`.
   - El campo `metadata.namespace` debe ser `demo-ns`.
3. Un **Pod** dentro del mismo namespace:
   - Nombre: `debug-pod`.
   - Imagen: `busybox`.
   - Comando: `["sleep", "3600"]`.
   - El campo `metadata.namespace` debe ser `demo-ns`.

El objetivo es entender cómo los Namespaces permiten agrupar y aislar recursos dentro de un cluster.

## Requisitos

- [ ] Existe un archivo `*.yaml` en la raíz del ejercicio.
- [ ] El manifiesto define un recurso de tipo `Namespace` llamado `demo-ns`.
- [ ] Existe un Deployment `nginx-deploy` con `metadata.namespace: demo-ns` y 2 réplicas.
- [ ] Existe un Pod `debug-pod` con `metadata.namespace: demo-ns`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un Namespace es un recurso del núcleo: `apiVersion: v1`, `kind: Namespace`.
- Para poner un recurso dentro de un namespace, usa `metadata.namespace: <nombre>`.
- Puedes poner varios recursos en un mismo archivo separándolos con `---`.
- Lista recursos de un namespace con `kubectl get pods -n demo-ns`.

Estructura:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demo-ns
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: demo-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
  namespace: demo-ns
spec:
  containers:
    - name: debug
      image: busybox
      command: ["sleep", "3600"]
```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `namespace.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demo-ns
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: demo-ns
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: debug-pod
  namespace: demo-ns
spec:
  containers:
    - name: debug
      image: busybox
      command: ["sleep", "3600"]
```

**Explicación:**

- El primer documento crea el Namespace `demo-ns`.
- Los recursos posteriores incluyen `namespace: demo-ns` en su `metadata`, por lo que se crean dentro de ese namespace.
- Sin esa anotación, los recursos irían al namespace `default`.
- Los Namespaces son útiles para separar entornos (dev/staging/prod) o equipos dentro de un mismo cluster.

Para aplicarlo en un cluster real:

```bash
kubectl apply -f namespace.yaml
kubectl get ns demo-ns
kubectl get deploy -n demo-ns
kubectl get pods -n demo-ns
```

</details>
