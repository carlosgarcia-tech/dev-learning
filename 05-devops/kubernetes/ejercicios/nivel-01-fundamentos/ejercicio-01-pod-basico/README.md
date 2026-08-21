# Ejercicio 01 - Pod básico

- **Nivel:** 1/5
- **Tema:** Pods y manifiestos YAML en Kubernetes
- **Tiempo estimado:** 15 min

## Enunciado

Crea un manifiesto YAML que defina un **Pod** en Kubernetes con las siguientes características:

- El Pod se debe llamar `nginx-pod`.
- Debe contener un único contenedor llamado `web`.
- La imagen del contenedor debe ser `nginx:alpine`.
- El contenedor debe exponer el puerto `80`.
- Usa las etiquetas (labels) `app: web` y `env: dev`.

El objetivo es familiarizarte con la estructura básica de un manifiesto de Pod en Kubernetes (`apiVersion`, `kind`, `metadata`, `spec`).

## Requisitos

- [ ] Existe un archivo `*.yaml` en la raíz del ejercicio.
- [ ] El manifiesto define un recurso de tipo `Pod`.
- [ ] El nombre del Pod es `nginx-pod`.
- [ ] Existe un contenedor llamado `web` con imagen `nginx:alpine`.
- [ ] El contenedor expone el puerto `80`.
- [ ] El Pod tiene las labels `app: web` y `env: dev`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La `apiVersion` para un Pod es `v1` y el `kind` es `Pod`.
- El nombre del recurso se define en `metadata.name`.
- Los contenedores se definen en la lista `spec.containers[]`.
- Cada contenedor tiene `name`, `image` y opcionalmente `ports[]`.
- Para exponer un puerto se usa `containerPort: 80` dentro de `ports`.
- Las labels van en `metadata.labels` (un mapa clave-valor).

Ejemplo de estructura:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: <nombre>
  labels:
    <clave>: <valor>
spec:
  containers:
    - name: <nombre-contenedor>
      image: <imagen>
      ports:
        - containerPort: <puerto>
```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: web
    env: dev
spec:
  containers:
    - name: web
      image: nginx:alpine
      ports:
        - containerPort: 80
```

**Explicación:**

- `apiVersion: v1` → versión de la API de Kubernetes para recursos del núcleo (como Pods).
- `kind: Pod` → tipo de recurso que estamos creando.
- `metadata.name` → nombre único del Pod dentro del namespace.
- `metadata.labels` → etiquetas clave-valor que luego sirven para seleccionar recursos.
- `spec.containers[]` → lista de contenedores del Pod. Aquí solo uno.
- `containerPort: 80` → puerto que el contenedor expone dentro del Pod (es informativo, no publica el puerto en el host).

Para aplicarlo en un cluster real:

```bash
kubectl apply -f pod.yaml
kubectl get pod nginx-pod
kubectl describe pod nginx-pod
```

</details>
