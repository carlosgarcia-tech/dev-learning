# Ejercicio 02 — Usuario no root (hardening)

- **Nivel:** 4/5
- **Tema:** `USER`, `--cap-drop`, `read_only`, `no-new-privileges`, `tmpfs`
- **Tiempo estimado:** 35 min

## Enunciado

Crea un `Dockerfile` y un `docker-compose.yml` que endurezcan un contenedor Node:

1. **Dockerfile**: crea un usuario `app` (UID 10001), copia el código con `--chown=app:app`, usa `USER app`.
2. **Compose**: 
   - `read_only: true` (filesystem de solo lectura).
   - `tmpfs: ["/tmp"]` (para que Node pueda escribir en /tmp si lo necesita).
   - `cap_drop: [ALL]` (dropea todas las capabilities de Linux).
   - `security_opt: [no-new-privileges:true]`.
   - `user: "10001:10001"`.

## Requisitos

- [ ] Dockerfile crea usuario con UID 10001 y usa `USER app`
- [ ] `COPY --chown=app:app` en el Dockerfile
- [ ] Compose con `read_only: true`
- [ ] Compose con `tmpfs: ["/tmp"]`
- [ ] Compose con `cap_drop: [ALL]`
- [ ] Compose con `security_opt: [no-new-privileges:true]`
- [ ] Compose con `user: "10001:10001"`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En alpine, para crear un usuario con UID específico: `addgroup -S -g 10001 app && adduser -S -D -H -u 10001 -G app app`.
- `read_only: true` monta el rootfs como solo lectura; Node necesita `/tmp` escribible, de ahí el `tmpfs`.
- `cap_drop: [ALL]` quita todos los permisos del kernel; si la app escucha en puerto <1024 necesitarías `cap_add: [NET_BIND_SERVICE]`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`Dockerfile`:

```dockerfile
FROM node:20-alpine
RUN addgroup -S -g 10001 app && adduser -S -D -H -u 10001 -G app app
WORKDIR /app
COPY --chown=app:app app/package.json ./
RUN npm ci --omit=dev
COPY --chown=app:app app/ ./
USER app
EXPOSE 3000
CMD ["node", "server.js"]
```

`docker-compose.yml`:

```yaml
services:
  app:
    build: .
    ports:
      - "8096:3000"
    read_only: true
    tmpfs:
      - /tmp
    cap_drop:
      - ALL
    security_opt:
      - no-new-privileges:true
    user: "10001:10001"
```

</details>
