# Ejercicio 18 - Probes liveness y readiness

- **Nivel:** 3/5
- **Tema:** Liveness y readiness probes
- **Tiempo estimado:** 25 min

## Enunciado

K8s monitoriza la salud de los contenedores con **probes**:

- **Liveness probe**: indica si el contenedor **está vivo**. Si falla, K8s **reinicia** el contenedor (política `restartPolicy`). Detecta deadlocks o procesos colgados.
- **Readiness probe**: indica si el contenedor **está listo para recibir tráfico**. Si falla, K8s **saca al pod del Service** (no recibe tráfico) pero no lo reinicia. Ideal para esperas de arranque (cargar datos, conectar a BD).

```
Liveness:  ¿el proceso responde?   NO → reiniciar contenedor
Readiness: ¿puede servir tráfico?  NO → sacar del Service (endpoints)
```

Debes crear un **Pod** `app-probes` con imagen `nginx:1.25` y dos probes:

1. **livenessProbe** (HTTP GET al path `/` en el puerto 80) con:
   - `initialDelaySeconds: 10`
   - `periodSeconds: 5`
   - `timeoutSeconds: 1`
   - `failureThreshold: 3`

2. **readinessProbe** (HTTP GET al path `/` en el puerto 80) con:
   - `initialDelaySeconds: 5`
   - `periodSeconds: 5`

> Usamos `nginx:1.25` porque arranca un servidor HTTP en el puerto 80, ideal para probar probes HTTP. El path `/` responde 200 OK mientras el nginx esté vivo.

## Requisitos

- [ ] Existe un Pod `app-probes` con imagen `nginx:1.25`.
- [ ] El Pod define una `livenessProbe` de tipo `httpGet` al path `/` puerto 80.
- [ ] La livenessProbe tiene `initialDelaySeconds: 10`, `periodSeconds: 5`, `timeoutSeconds: 1` y `failureThreshold: 3`.
- [ ] El Pod define una `readinessProbe` de tipo `httpGet` al path `/` puerto 80.
- [ ] La readinessProbe tiene `initialDelaySeconds: 5` y `periodSeconds: 5`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las probes se definen a nivel de **contenedor**, dentro de `spec.containers[].livenessProbe` y `spec.containers[].readinessProbe`.
- Los tres tipos de probe son: `httpGet` (HTTP), `tcpSocket` (TCP), `exec` (ejecutar un comando).
- Para `httpGet` necesitas `path`, `port` y opcionalmente `host`. El puerto puede ser un número o el nombre de un puerto del contenedor.
- `initialDelaySeconds` es clave: si lo pones a 0, K8s puede reiniciar el contenedor antes de que la app arranque. Para nginx, 10s suele bastar.
- `failureThreshold` es cuántas veces seguidas debe fallar antes de considerar el probe fallido.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# pod-probes.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-probes
  labels:
    app: app-probes
spec:
  containers:
    - name: nginx
      image: nginx:1.25
      ports:
        - containerPort: 80
      livenessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 10
        periodSeconds: 5
        timeoutSeconds: 1
        failureThreshold: 3
      readinessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 5
        periodSeconds: 5
```

</details>
