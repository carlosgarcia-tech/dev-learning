# Ejercicio 13 - PersistentVolume y PersistentVolumeClaim

- **Nivel:** 3/5
- **Tema:** Almacenamiento persistente (PV y PVC)
- **Tiempo estimado:** 25 min

## Enunciado

En los ejercicios anteriores usaste volúmenes efímeros (`emptyDir`), cuyos datos se pierden cuando el pod se reinicia o se borra. Ahora vas a usar **almacenamiento persistente**: un **PersistentVolume (PV)** que representa un trozo de disco del cluster, y un **PersistentVolumeClaim (PVC)** que es la petición que hace un usuario para reservar parte de ese volumen.

Debes crear:

1. Un **PersistentVolume** `pv-datos` de `2Gi`, con `accessModes: ReadWriteOnce` y un `hostPath` apuntando a `/mnt/datos`.
2. Un **PersistentVolumeClaim** `pvc-datos` que pida `2Gi` en modo `ReadWriteOnce`.
3. Un **Pod** `app-pv` con imagen `nginx:1.25` que monte el PVC en `/usr/share/nginx/html`.

```
Pod (nginx) → volumeMounts → PVC (pvc-datos) → PV (pv-datos) → hostPath (/mnt/datos)
```

## Requisitos

- [ ] Existe un PersistentVolume `pv-datos` con `capacity.storage: 2Gi` y `accessModes: ReadWriteOnce`.
- [ ] El PV define un `hostPath` con `path: /mnt/datos`.
- [ ] Existe un PersistentVolumeClaim `pvc-datos` que pide `2Gi` en modo `ReadWriteOnce`.
- [ ] Existe un Pod `app-pv` con imagen `nginx:1.25`.
- [ ] El Pod monta el PVC `pvc-datos` en `/usr/share/nginx/html`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El flujo es: defines el **PV** (recurso del cluster), defines el **PVC** (petición del usuario), y K8s los **vincula** porque coinciden en tamaño y accessMode.
- El campo que vincula pod con PVC está en `spec.volumes[].persistentVolumeClaim.claimName`.
- Recuerda que el nombre del `volume` (en `volumes`) debe coincidir con el `name` del `volumeMounts`.
- `persistentVolumeReclaimPolicy: Retain` hace que al borrar el PVC los datos se conserven.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-datos
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/datos
```

```yaml
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-datos
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

```yaml
# pod-pvc.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pv
  labels:
    app: app-pv
spec:
  containers:
    - name: nginx
      image: nginx:1.25
      volumeMounts:
        - name: datos
          mountPath: /usr/share/nginx/html
  volumes:
    - name: datos
      persistentVolumeClaim:
        claimName: pvc-datos
```

</details>
