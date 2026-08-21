# Ejercicio 11 - Volumen emptyDir compartido entre 2 contenedores

- **Nivel:** 2/5
- **Tema:** Volúmenes de pod: `emptyDir` para compartir datos entre contenedores
- **Tiempo estimado:** 25 min

## Enunciado

Crea un **Pod** con **dos contenedores** (`writer` y `reader`) que compartan un volumen
de tipo `emptyDir`. El contenedor `writer` escribe periódicamente la fecha en un fichero
`/data/hello.txt`, y el contenedor `reader` lo lee y lo imprime.

Un `emptyDir` es un volumen que se crea **vacío** cuando el pod se asigna a un nodo y
existe mientras el pod se ejecuta en ese nodo. Todos los contenedores del pod pueden
montarlo y compartir ficheros a través de él. Cuando el pod se elimina, el contenido del
`emptyDir` se pierde.

## Requisitos

- [ ] Un Pod `shared-volume-pod` con dos contenedores: `writer` y `reader`.
- [ ] Un volumen `shared-data` de tipo `emptyDir`.
- [ ] Ambos contenedores montan el volumen en `/data`.
- [ ] El `writer` escribe en `/data/hello.txt` y el `reader` lee de `/data/hello.txt`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` de un Pod es `v1` y el `kind` es `Pod`.
- Un `emptyDir` se declara sin parámetros:
  ```yaml
  volumes:
    - name: shared-data
      emptyDir: {}
  ```
- Cada contenedor lo monta con `volumeMounts`:
  ```yaml
  volumeMounts:
    - name: shared-data
      mountPath: /data
  ```
- Ambos contenedores comparten la red del pod, pero los procesos NO comparten sistema de
  ficheros salvo que monten el mismo volumen.
- Para probarlo en un cluster real:
  ```bash
  kubectl apply -f pod.yaml
  kubectl logs shared-volume-pod -c reader
  kubectl logs shared-volume-pod -c writer
  ```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shared-volume-pod
  labels:
    app: shared-volume
spec:
  containers:
    - name: writer
      image: busybox:1.36
      command: ["sh", "-c", "while true; do echo \"$(date)\" > /data/hello.txt; sleep 5; done"]
      volumeMounts:
        - name: shared-data
          mountPath: /data
    - name: reader
      image: busybox:1.36
      command: ["sh", "-c", "while true; do cat /data/hello.txt 2>/dev/null || echo 'esperando...'; sleep 5; done"]
      volumeMounts:
        - name: shared-data
          mountPath: /data
  volumes:
    - name: shared-data
      emptyDir: {}
  restartPolicy: Never
```

</details>
