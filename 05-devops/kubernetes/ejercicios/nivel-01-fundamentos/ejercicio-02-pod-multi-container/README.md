# Ejercicio 02 - Pod multi-container (patrón sidecar)

- **Nivel:** 1/5
- **Tema:** Pods con varios contenedores y patrón sidecar
- **Tiempo estimado:** 25 min

## Enunciado

Crea un manifiesto YAML que defina un **Pod** con **dos contenedores** que colaboran usando un **volumen compartido** (patrón sidecar):

- El Pod se llama `web-logs`.
- **Contenedor 1 (`nginx`):** usa la imagen `nginx:alpine` y:
  - Expone el puerto `80`.
  - Monta un volumen compartido llamado `shared-logs` en `/var/log/nginx`.
- **Contenedor 2 (`logger`, sidecar):** usa la imagen `busybox` y:
  - Lee continuamente los logs de nginx desde el volumen compartido.
  - Monta el mismo volumen `shared-logs` en `/var/log/nginx`.
  - Comando: `["/bin/sh", "-c", "tail -f /var/log/nginx/access.log"]`
- Define un volumen de tipo `emptyDir` llamado `shared-logs`.
- Labels: `app: web-logs`.

El objetivo es entender que los contenedores de un mismo Pod comparten red y pueden compartir volúmenes, lo que permite patrones como el sidecar.

## Requisitos

- [ ] Existe un archivo `*.yaml` en la raíz del ejercicio.
- [ ] El manifiesto define un recurso de tipo `Pod` llamado `web-logs`.
- [ ] El Pod tiene exactamente **2 contenedores**: `nginx` y `logger`.
- [ ] El contenedor `nginx` usa la imagen `nginx:alpine` y expone el puerto `80`.
- [ ] El contenedor `logger` usa la imagen `busybox`.
- [ ] Ambos contenedores montan el volumen `shared-logs` en `/var/log/nginx`.
- [ ] Existe un volumen `shared-logs` de tipo `emptyDir`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un Pod puede tener varios contenedores en `spec.containers[]`.
- Para compartir datos entre contenedores del mismo Pod, define un volumen en `spec.volumes[]` y móntalo en cada contenedor con `volumeMounts[]`.
- El tipo de volumen más simple para compartir efímeramente es `emptyDir`.
- El comando del sidecar se define con `command` (lista de strings) o `args`.
- Ambos contenedores deben montar el volumen en la **misma ruta** para que se vean los archivos.

Estructura general:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-logs
  labels:
    app: web-logs
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}
  containers:
    - name: nginx
      image: nginx:alpine
      ports:
        - containerPort: 80
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
    - name: logger
      image: busybox
      command: ["/bin/sh", "-c", "tail -f /var/log/nginx/access.log"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `pod-multi.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-logs
  labels:
    app: web-logs
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}
  containers:
    - name: nginx
      image: nginx:alpine
      ports:
        - containerPort: 80
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
    - name: logger
      image: busybox
      command: ["/bin/sh", "-c", "tail -f /var/log/nginx/access.log"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

**Explicación:**

- `spec.volumes[]` define el volumen `shared-logs` como `emptyDir` (se crea vacío y se borra cuando el Pod muere).
- Cada contenedor lo monta en `volumeMounts[]` con el mismo `mountPath`, de modo que ambos ven el mismo contenido.
- El contenedor `nginx` escribe sus logs en `/var/log/nginx/access.log`.
- El sidecar `logger` hace `tail -f` sobre ese archivo y muestra los logs en tiempo real.
- Al compartir `localhost` (mismo Pod), los contenedores también podrían comunicarse por red en `127.0.0.1`.

Para aplicarlo en un cluster real:

```bash
kubectl apply -f pod-multi.yaml
kubectl logs web-logs -c logger   # ver los logs que lee el sidecar
```

</details>
