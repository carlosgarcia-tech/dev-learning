# Ejercicio 28 - Deployment blue-green

- **Nivel:** 5/5
- **Tema:** Estrategia de despliegue blue-green
- **Tiempo estimado:** 30 min

## Enunciado

El despliegue **blue-green** mantiene dos entornos idénticos: uno activo (sirve
tráfico) y otro inactivo (preparando la nueva versión). Para cambiar de versión, basta
con cambiar el selector del Service de `blue` a `green`, y el tráfico cambia al instante
sin downtime.

Crea:
- Un Deployment **blue** (versión actual, ej. `nginx:1.25`) con label `slot: blue`.
- Un Deployment **green** (nueva versión, ej. `nginx:1.27`) con label `slot: green`.
- Un Service `api` cuyo `selector` apunta a `blue` (entorno activo).

> La ventaja sobre el canary es que el cambio es instantáneo y reversible: solo cambias
> `slot: blue` -> `slot: green` en el Service y listo.

## Requisitos

- [ ] Un Deployment `api-blue` con label `slot: blue`.
- [ ] Un Deployment `api-green` con label `slot: green`.
- [ ] Un Service `api` con `selector.slot: blue` (activo es blue).
- [ ] Ambos Deployments comparten el label `app: api`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Ambos Deployments usan el mismo `app: api` pero distinto `slot`.
- El selector del Service usa `app: api` + `slot: blue` (el slot activo).
- Para hacer el switch, edita el Service: `kubectl edit svc api` y cambia `slot: blue`
  por `slot: green`.
- Cada Deployment tiene su propio `spec.selector.matchLabels` con su `slot`.
- Las réplicas pueden ser iguales (ej. 3 y 3) porque solo una recibe tráfico a la vez.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment-blue.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-blue
  labels:
    app: api
    slot: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
      slot: blue
  template:
    metadata:
      labels:
        app: api
        slot: blue
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - containerPort: 80
```

`deployment-green.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-green
  labels:
    app: api
    slot: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
      slot: green
  template:
    metadata:
      labels:
        app: api
        slot: green
    spec:
      containers:
        - name: api
          image: nginx:1.27
          ports:
            - containerPort: 80
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
    slot: blue
  ports:
    - port: 80
      targetPort: 80
```

</details>
