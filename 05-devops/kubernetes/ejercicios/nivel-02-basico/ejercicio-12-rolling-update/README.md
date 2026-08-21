# Ejercicio 12 - Deployment con estrategia RollingUpdate y rollout history

- **Nivel:** 2/5
- **Tema:** Estrategias de actualización de Deployments y gestión de rollouts
- **Tiempo estimado:** 30 min

## Enunciado

Crea un **Deployment** con 3 réplicas de `nginx` que use la estrategia
`RollingUpdate` con `maxSurge: 1` y `maxUnavailable: 0`. Añade la anotación
`kubernetes.io/change-cause` para documentar el despliegue.

Después, en un cluster real, practica el ciclo completo de actualizaciones:

1. Despliega la versión inicial (`nginx:1.25`).
2. Actualiza la imagen a `nginx:1.26` y observa el rollout.
3. Consulta el historial de revisiones.
4. Haz un rollback a la versión anterior con `kubectl rollout undo`.

La estrategia `RollingUpdate` crea pods nuevos **antes** de borrar los viejos, garantizando
**cero downtime** cuando `maxUnavailable: 0`.

## Requisitos

- [ ] Un Deployment `web` con 3 réplicas de `nginx`.
- [ ] La estrategia es `RollingUpdate` con `maxSurge: 1` y `maxUnavailable: 0`.
- [ ] La anotación `kubernetes.io/change-cause` está presente en los metadatos.
- [ ] El `selector.matchLabels` coincide con `template.metadata.labels`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La estrategia se define en `spec.strategy`:
  ```yaml
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # pods extra máximos durante el update
      maxUnavailable: 0    # pods no disponibles máximos (0 = cero downtime)
  ```
- Para que el `CHANGE-CAUSE` del historial tenga sentido, añade la anotación:
  ```yaml
  metadata:
    annotations:
      kubernetes.io/change-cause: "Despliegue inicial con nginx 1.25"
  ```
- Comandos de rollout:
  ```bash
  # Aplicar el manifiesto inicial
  kubectl apply -f deployment.yaml

  # Actualizar la imagen (dispara un nuevo rollout)
  kubectl set image deployment/web nginx=nginx:1.26
  kubectl annotate deployment/web kubernetes.io/change-cause="Actualización a nginx 1.26" --record=false

  # Ver el estado del rollout
  kubectl rollout status deployment/web

  # Ver el historial de revisiones
  kubectl rollout history deployment/web

  # Hacer rollback a la revisión anterior
  kubectl rollout undo deployment/web

  # Hacer rollback a una revisión concreta
  kubectl rollout undo deployment/web --to-revision=1
  ```
- `maxSurge: 1` significa que durante el rollout puede haber hasta 1 pod extra (3+1=4).
- `maxUnavailable: 0` significa que nunca hay menos de 3 pods disponibles.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  labels:
    app: web
  annotations:
    kubernetes.io/change-cause: "Despliegue inicial con nginx 1.25"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
```

</details>
