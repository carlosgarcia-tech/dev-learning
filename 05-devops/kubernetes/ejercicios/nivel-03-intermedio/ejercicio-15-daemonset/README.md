# Ejercicio 15 - DaemonSet

- **Nivel:** 3/5
- **Tema:** DaemonSet (un pod en cada nodo)
- **Tiempo estimado:** 25 min

## Enunciado

Un **DaemonSet** garantiza que **cada nodo** del cluster ejecute una copia de un pod. Es el recurso ideal para componentes que deben estar en todos los nodos: agentes de logging (Fluentd/Fluent Bit), monitorización (Prometheus Node Exporter), red (CNI) o almacenamiento.

En este ejercicio vas a desplegar un **collector de logs** (`fluentd`) en cada nodo, que lee los logs del sistema (`/var/log`) y de los contenedores (`/var/lib/docker/containers`). Es el caso de uso más clásico de un DaemonSet.

Debes crear un **DaemonSet** `log-collector` con:

1. Imagen `fluent/fluentd:v1.16`.
2. Selector y labels `app: log-collector`.
3. Recursos: requests y limits (CPU y memoria).
4. Un volumen `hostPath` de `/var/log` montado como `readOnly: true` en `/var/log`.
5. Un segundo volumen `hostPath` de `/var/lib/docker/containers` montado como `readOnly: true` en `/var/lib/docker/containers`.

```
DaemonSet log-collector
  ├── Pod en nodo-1 (lee /var/log y /var/lib/docker/containers del nodo-1)
  ├── Pod en nodo-2 (lee /var/log y /var/lib/docker/containers del nodo-2)
  └── Pod en nodo-3 (lee /var/log y /var/lib/docker/containers del nodo-3)
```

## Requisitos

- [ ] Existe un DaemonSet `log-collector`.
- [ ] El DaemonSet usa imagen `fluent/fluentd:v1.16`.
- [ ] El selector y los labels del template coinciden en `app: log-collector`.
- [ ] El contenedor define `resources.requests` y `resources.limits` (CPU y memoria).
- [ ] Hay un volumen `hostPath` `/var/log` montado como `readOnly: true`.
- [ ] Hay un volumen `hostPath` `/var/lib/docker/containers` montado como `readOnly: true`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La estructura de un DaemonSet es casi idéntica a un Deployment: `spec.selector`, `spec.template`. La diferencia es que **no** tiene `replicas` (un pod por nodo, automáticamente).
- Los `volumes` se definen en `spec.template.spec.volumes` (a nivel de pod), y se montan con `volumeMounts` dentro de cada contenedor.
- `hostPath` monta un directorio del **nodo host** dentro del pod. Úsalo solo para pods de sistema (como un collector de logs).
- `readOnly: true` en el `volumeMount` evita que el pod pueda escribir en los logs del host.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
  labels:
    app: log-collector
spec:
  selector:
    matchLabels:
      app: log-collector
  template:
    metadata:
      labels:
        app: log-collector
    spec:
      containers:
        - name: fluentd
          image: fluent/fluentd:v1.16
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "200m"
              memory: "256Mi"
          volumeMounts:
            - name: varlog
              mountPath: /var/log
              readOnly: true
            - name: varlibdockercontainers
              mountPath: /var/lib/docker/containers
              readOnly: true
      volumes:
        - name: varlog
          hostPath:
            path: /var/log
            type: Directory
        - name: varlibdockercontainers
          hostPath:
            path: /var/lib/docker/containers
            type: Directory
```

</details>
