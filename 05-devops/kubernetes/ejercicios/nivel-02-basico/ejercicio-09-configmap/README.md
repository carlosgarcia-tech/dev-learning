# Ejercicio 09 - ConfigMap como variables de entorno y como fichero

- **Nivel:** 2/5
- **Tema:** ConfigMap: inyección de configuración por env y por volumen
- **Tiempo estimado:** 25 min

## Enunciado

Crea un **ConfigMap** llamado `app-config` con varias claves de configuración y un
**Pod** que consuma ese ConfigMap de **dos formas**:

1. Como **variables de entorno** (`env.valueFrom.configMapKeyRef`) para `LOG_LEVEL` y
   `ENTORNO`.
2. Como **fichero** montado en un volumen (`volumes.configMap`), de modo que cada clave
  del ConfigMap se convierta en un fichero dentro del directorio montado.

El patrón más usado en producción: valores simples como variables de entorno y
ficheros de configuración completos (JSON, YAML, properties) como ficheros montados.

## Requisitos

- [ ] Un ConfigMap `app-config` con al menos las claves `LOG_LEVEL`, `ENTORNO` y una
      clave de tipo fichero (p. ej. `config.yaml`).
- [ ] Un Pod `app` que inyecte `LOG_LEVEL` y `ENTORNO` como variables de entorno desde
      el ConfigMap.
- [ ] El Pod monta el ConfigMap como volumen en `/etc/config`.
- [ ] El nombre del volumen referenciado en `volumeMounts` y en `volumes` coincide.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` de un ConfigMap es `v1` y el `kind` es `ConfigMap`.
- Para inyectar una clave como variable de entorno:
  ```yaml
  env:
    - name: LOG_LEVEL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: LOG_LEVEL
  ```
- Para montar todo el ConfigMap como ficheros:
  ```yaml
  volumes:
    - name: config-volume
      configMap:
        name: app-config
  ```
  Cada clave del ConfigMap se convierte en un fichero dentro del `mountPath`.
- Si quieres que `configMapKeyRef` sea opcional (no falle si la clave no existe), usa
  `optional: true`.
- Para probarlo en un cluster real:
  ```bash
  kubectl apply -f configmap.yaml -f pod.yaml
  kubectl exec app -- env | grep -E 'LOG_LEVEL|ENTORNO'
  kubectl exec app -- cat /etc/config/config.yaml
  ```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  labels:
    app: app
data:
  LOG_LEVEL: "info"
  ENTORNO: "desarrollo"
  config.yaml: |
    servidor:
      puerto: 8080
      host: 0.0.0.0
    debug: false
```

`pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
  labels:
    app: app
spec:
  containers:
    - name: app
      image: busybox:1.36
      command: ["sh", "-c", "env | grep -E 'LOG_LEVEL|ENTORNO' && cat /etc/config/config.yaml && sleep 3600"]
      env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: LOG_LEVEL
        - name: ENTORNO
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: ENTORNO
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: app-config
  restartPolicy: Never
```

</details>
