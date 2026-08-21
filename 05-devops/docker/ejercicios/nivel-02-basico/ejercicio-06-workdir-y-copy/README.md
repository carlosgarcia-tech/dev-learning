# Ejercicio 06 — WORKDIR y COPY

- **Nivel:** 2/5
- **Tema:** `WORKDIR`, `COPY` con rutas relativas, `chown`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un `Dockerfile` que demuestre el uso correcto de `WORKDIR` y `COPY` con rutas relativas y permisos.

1. Base `node:20-alpine`.
2. `WORKDIR /app` (establece el cwd para las siguientes instrucciones).
3. Crea un usuario no root `app` con `addgroup`/`adduser`.
4. Copia `app/package.json` al WORKDIR con `COPY --chown=app:app package.json ./` (ruta relativa al WORKDIR).
5. `RUN npm ci --omit=dev`.
6. Copia el resto con `COPY --chown=app:app app/ ./`.
7. `USER app`.
8. `EXPOSE 3000`.
9. `CMD ["node", "server.js"]`.

## Requisitos

- [ ] `FROM node:20-alpine`
- [ ] `WORKDIR /app`
- [ ] Creación de usuario `app` con `addgroup`/`adduser`
- [ ] `COPY --chown=app:app` para package.json y para el código
- [ ] `USER app` antes del CMD
- [ ] `CMD ["node", "server.js"]` (forma exec)
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `WORKDIR /app` hace que `COPY ... ./` copie dentro de `/app`.
- `COPY --chown=app:app` copia y ajusta el propietario en un mismo paso (mejor que `RUN chown -R` después, que duplica capa).
- En alpine: `RUN addgroup -S app && adduser -S app -G app`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
COPY --chown=app:app app/package.json ./
RUN npm ci --omit=dev
COPY --chown=app:app app/ ./
USER app
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
