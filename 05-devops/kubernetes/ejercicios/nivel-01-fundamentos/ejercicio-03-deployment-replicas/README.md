# Ejercicio 03 - Deployment con réplicas

- **Nivel:** 1/5
- **Tema:** Deployments y escalado de Pods
- **Tiempo estimado:** 20 min

## Enunciado

Crea un manifiesto YAML que defina un **Deployment** de Kubernetes con las siguientes características:

- El Deployment se llama `nginx-deploy`.
- Usa la imagen `nginx:alpine`.
- Debe tener **3 réplicas** (`replicas: 3`).
- El contenedor se llama `nginx` y expone el puerto `80`.
- Incluye un **selector** que coincida con las labels del template del Pod.
- Labels del Pod template: `app: nginx`.
- Namespace por defecto (`default`).

El objetivo es entender cómo un Deployment mantiene un número deseado de réplicas de un Pod y cómo se relaciona el `selector` con el `template`.

## Requisitos

- [ ] Existe un archivo `*.yaml` en la raíz del ejercicio.
- [ ] El manifiesto define un recurso de tipo `Deployment` llamado `nginx-deploy`.
- [ ] El número de réplicas es **3**.
- [ ] El contenedor se llama `nginx`, usa la imagen `nginx:alpine` y expone el puerto `80`.
- [ ] El `selector.matchLabels` coincide con las labels del `template`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La `apiVersion` para un Deployment es `apps/v1`.
- El `kind` es `Deployment`.
- El número de réplicas se define en `spec.replicas`.
- El `spec.selector.matchLabels` indica qué Pods gestiona el Deployment; **debe coincidir** con `spec.template.metadata.labels`.
- El template del Pod va en `spec.template`.

Estructura:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
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
          ports:
            - containerPort: 80
```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
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
          ports:
            - containerPort: 80
```

**Explicación:**

- `apiVersion: apps/v1` → grupo de APIs para recursos de "cargas de trabajo" (Deployments, ReplicaSets, etc.).
- `spec.replicas: 3` → el Deployment intentará mantener siempre 3 Pods corriendo.
- `spec.selector.matchLabels` → define qué Pods pertenecen a este Deployment. Si no coincide con el template, Kubernetes rechaza el manifiesto.
- `spec.template` → el "molde" del Pod que se va a replicar 3 veces.
- Si un Pod cae, el Deployment crea otro automáticamente para mantener las 3 réplicas.

Para aplicarlo en un cluster real:

```bash
kubectl apply -f deployment.yaml
kubectl get deploy nginx-deploy
kubectl get pods -l app=nginx
# Escalar a 5 réplicas:
kubectl scale deploy nginx-deploy --replicas=5
```

</details>
