# Ejercicio 10 - Secret inyectado como variable de entorno

- **Nivel:** 2/5
- **Tema:** Secrets: almacenamiento de datos sensibles e inyección en el pod
- **Tiempo estimado:** 25 min

## Enunciado

Crea un **Secret** llamado `app-secret` con dos datos sensibles (`API_KEY` y
`DB_PASSWORD`) y un **Pod** que los consuma como **variables de entorno** mediante
`secretKeyRef`.

Los Secrets sirven para almacenar información confidencial (contraseñas, tokens, claves
API). A diferencia de los ConfigMaps, sus valores se almacenan **codificados en base64**
y (por defecto) no se imprimen en pantalla con `kubectl describe`.

> **Importante:** el base64 es **codificación**, no **encriptación**. Cualquiera con
> acceso al Secret puede decodificarlo. Para protección real usa herramientas como
> `Sealed Secrets` o `SOPS` (ver guía 05).

## Requisitos

- [ ] Un Secret `app-secret` de tipo `Opaque` con las claves `API_KEY` y `DB_PASSWORD`
      codificadas en base64.
- [ ] Un Pod `app` que inyecte ambas claves como variables de entorno desde el Secret.
- [ ] El `secretKeyRef` referencia correctamente al nombre y clave del Secret.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` de un Secret es `v1` y el `kind` es `Secret`.
- Los valores en `data` van **codificados en base64**, no en texto plano:
  ```bash
  echo -n 'mi-password' | base64
  # bWktcGFzc3dvcmQ=
  ```
- Para inyectar un Secret como variable de entorno:
  ```yaml
  env:
    - name: API_KEY
      valueFrom:
        secretKeyRef:
          name: app-secret
          key: API_KEY
  ```
- Alternativa: si no quieres lidiar con base64, usa `stringData` en vez de `data` y K8s
  lo codifica automáticamente:
  ```yaml
  stringData:
    API_KEY: mi-clave-en-texto-plano
  ```
- Para probarlo en un cluster real:
  ```bash
  kubectl apply -f secret.yaml -f pod.yaml
  kubectl exec app -- env | grep -E 'API_KEY|DB_PASSWORD'
  # Ver el valor decodificado:
  kubectl get secret app-secret -o jsonpath='{.data.API_KEY}' | base64 -d
  ```

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
  labels:
    app: app
type: Opaque
data:
  API_KEY: Y2hhbmdlLW1lLXNlY3JldC1rZXktMTIzNDU2
  DB_PASSWORD: cGFzc3dvcmQtc2VjcmV0by0xMjM=
```

Valores decodificados (solo para referencia, **no** se guardan en texto plano):

```
API_KEY:      change-me-secret-key-123456
DB_PASSWORD:  password-secreto-123
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
      command: ["sh", "-c", "env | grep -E 'API_KEY|DB_PASSWORD' && sleep 3600"]
      env:
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: API_KEY
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_PASSWORD
  restartPolicy: Never
```

</details>
