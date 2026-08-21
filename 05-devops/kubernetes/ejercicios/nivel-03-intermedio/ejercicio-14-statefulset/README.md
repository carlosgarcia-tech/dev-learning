# Ejercicio 14 - StatefulSet

- **Nivel:** 3/5
- **Tema:** StatefulSet con headless service y volumeClaimTemplates
- **Tiempo estimado:** 30 min

## Enunciado

Un **StatefulSet** es como un Deployment, pero pensado para aplicaciones con estado (bases de datos, colas, sistemas distribuidos). A diferencia de un Deployment, garantiza:

- Nombres estables y ordenados: `app-0`, `app-1`, `app-2` (no nombres aleatorios).
- DNS estable: cada pod tiene su propia entrada DNS.
- Almacenamiento estable: cada pod tiene su propio volumen persistente gracias a `volumeClaimTemplates`.
- Orden de arranque y apagado: `app-0` antes que `app-1`, etc.

Debes crear un StatefulSet de base de datos PostgreSQL:

1. Un **headless Service** `postgres` (`clusterIP: None`) que selecciona pods con `app: postgres`.
2. Un **StatefulSet** `postgres` con:
   - `replicas: 3`
   - imagen `postgres:16`
   - variable de entorno `POSTGRES_PASSWORD`
   - `serviceName: postgres` (el headless service asociado)
   - `volumeClaimTemplates` que cree un PVC de `5Gi` por pod en modo `ReadWriteOnce`.
   - el volumen montado en `/var/lib/postgresql/data`.

> Cada pod será accesible por DNS estable: `postgres-0.postgres.default.svc.cluster.local`

## Requisitos

- [ ] Existe un Service `postgres` con `clusterIP: None` (headless) y selector `app: postgres`.
- [ ] Existe un StatefulSet `postgres` con `replicas: 3`.
- [ ] El StatefulSet define `serviceName: postgres`.
- [ ] El StatefulSet usa imagen `postgres:16` y define la variable `POSTGRES_PASSWORD`.
- [ ] El StatefulSet define `volumeClaimTemplates` con `storage: 5Gi` y `ReadWriteOnce`.
- [ ] El volumen está montado en `/var/lib/postgresql/data`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un StatefulSet **siempre** necesita un headless Service (`clusterIP: None`) para dar DNS estable a cada pod.
- `serviceName` en el StatefulSet debe apuntar al nombre del headless Service.
- `volumeClaimTemplates` está al mismo nivel que `spec.selector` y `spec.template`, NO dentro del template.
- El `name` del `volumeClaimTemplates` es el que usas luego en `volumeMounts.name`.
- El selector del StatefulSet debe coincidir con las labels del template.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# headless-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
  labels:
    app: postgres
spec:
  clusterIP: None
  selector:
    app: postgres
  ports:
    - port: 5432
      name: postgres
```

```yaml
# statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
          ports:
            - containerPort: 5432
              name: postgres
          env:
            - name: POSTGRES_PASSWORD
              value: "secreto123"
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 5Gi
```

</details>
