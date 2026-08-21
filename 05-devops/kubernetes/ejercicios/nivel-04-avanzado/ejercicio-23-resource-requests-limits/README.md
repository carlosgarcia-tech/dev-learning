# Ejercicio 23 - Resource requests y limits

- **Nivel:** 4/5
- **Tema:** Gestión de recursos (CPU y memoria) en contenedores
- **Tiempo estimado:** 20 min

## Enunciado

Crea un **Deployment** que defina `requests` y `limits` de CPU y memoria para sus
contenedores. Los `requests` garantizan recursos al pod (para el scheduling), y los
`limits` imponen un máximo que el contenedor no puede superar.

El Deployment debe:
- Tener 3 réplicas.
- Cada contenedor debe definir `resources.requests` y `resources.limits` con `cpu` y
  `memory`.
- Los `limits` deben ser mayores o iguales que los `requests`.

> Definir recursos correctamente es esencial para que el scheduler coloque los pods en
> nodos con capacidad y para que el HPA (ejercicio 19) pueda calcular la utilización.

## Requisitos

- [ ] Un Deployment con al menos 3 réplicas.
- [ ] El contenedor define `resources.requests.cpu` y `resources.requests.memory`.
- [ ] El contenedor define `resources.limits.cpu` y `resources.limits.memory`.
- [ ] Los `limits` son >= que los `requests`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los recursos se definen en `spec.template.spec.containers[].resources`.
- `requests` y `limits` son dos secciones dentro de `resources`.
- La CPU se mide en milicores (`100m` = 0.1 núcleo) o núcleos (`1`).
- La memoria se mide en Mi/Gi (`128Mi`, `1Gi`).
- Es buena práctica que `limits` sea 2x los `requests` para dar margen de burst.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  labels:
    app: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 200m
              memory: 256Mi
```

`service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 80
```

</details>
