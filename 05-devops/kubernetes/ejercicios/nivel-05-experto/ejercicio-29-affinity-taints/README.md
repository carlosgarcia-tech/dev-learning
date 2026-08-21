# Ejercicio 29 - Affinity anti-affinity y taints tolerations

- **Nivel:** 5/5
- **Tema:** Scheduling avanzado: podAntiAffinity y tolerations
- **Tiempo estimado:** 40 min

## Enunciado

En producción quieres que las réplicas de un Deployment se repartan por distintos nodos
para resistir fallos de un nodo (**podAntiAffinity**), y que además puedan correr en nodos
con *taints* especiales (ej. nodos dedicados a GPU o a un workload específico) mediante
**tolerations**.

Crea un Deployment que:
- Tenga **3 réplicas**.
- Defina `podAntiAffinity` para que los pods prefieran no coincidir en el mismo nodo
  (`preferredDuringSchedulingIgnoredDuringExecution`), usando el label `app` como
  topología.
- Defina una **toleration** que permita ejecutarse en nodos con el taint
  `dedicated=gpu:NoSchedule`.
- Defina `nodeSelector` o `nodeAffinity` para preferir nodos con label `disktype=ssd`.

> `podAntiAffinity` distribuye los pods entre nodos para alta disponibilidad.
> `tolerations` permite que los pods toleren taints que repelerían a otros pods.

## Requisitos

- [ ] Un Deployment con 3 réplicas.
- [ ] `spec.affinity.podAntiAffinity` con `preferredDuringSchedulingIgnoredDuringExecution`.
- [ ] La anti-affinity usa `topologyKey: kubernetes.io/hostname`.
- [ ] Una `toleration` para `dedicated=gpu:NoSchedule`.
- [ ] `nodeSelector` con `disktype: ssd` (o `nodeAffinity` equivalente).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `podAntiAffinity` se define en `spec.affinity.podAntiAffinity`.
- `preferredDuringScheduling` es una pista (no garantía) para el scheduler: intentará no
  colocar dos pods con el mismo `app` en el mismo `topologyKey` (hostname = nodo).
- El `topologyKey` más común es `kubernetes.io/hostname` (un nodo = un dominio de topología).
- `tolerations` se define en `spec.tolerations` con `key`, `value`, `effect` y `operator`.
  Para `dedicated=gpu:NoSchedule`: `key: dedicated`, `value: gpu`, `effect: NoSchedule`,
  `operator: Equal`.
- `nodeSelector` es la forma simple: `spec.nodeSelector: {disktype: ssd}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-ha
  labels:
    app: api-ha
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-ha
  template:
    metadata:
      labels:
        app: api-ha
    spec:
      nodeSelector:
        disktype: ssd
      tolerations:
        - key: dedicated
          value: gpu
          effect: NoSchedule
          operator: Equal
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 100
              podAffinityTerm:
                labelSelector:
                  matchLabels:
                    app: api-ha
                topologyKey: kubernetes.io/hostname
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - containerPort: 80
```

</details>
