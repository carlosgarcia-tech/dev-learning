# Ejercicio 03 — Exponer puerto con app Node

- **Nivel:** 1/5
- **Tema:** `COPY`, `EXPOSE`, `CMD`, app Node, `npm ci`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un `Dockerfile` para una aplicación Node.js simple que sirve HTTP en el puerto 3000.

1. Base `node:20-alpine`.
2. `WORKDIR /app`.
3. Copia primero `package.json` y `package-lock.json` y ejecuta `npm ci --omit=dev` (aprovechar cache).
4. Copia el resto del código (`app/`) al WORKDIR.
5. `EXPOSE 3000`.
6. `CMD ["node", "server.js"]`.

Al ejecutar `docker run -p 3000:3000 <imagen>`, `http://localhost:3000` debe responder `{"ok":true}`.

## Requisitos

- [ ] `FROM node:20-alpine`
- [ ] `WORKDIR /app`
- [ ] Copia `package.json` (y lock) **antes** que el resto del código (optimización de cache)
- [ ] `RUN npm ci --omit=dev`
- [ ] Copia el código de `app/`
- [ ] `EXPOSE 3000`
- [ ] `CMD ["node", "server.js"]` (forma exec)
- [ ] Existe `.dockerignore` con `node_modules`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Copiar `package*.json` antes que el `COPY . .` hace que `npm ci` se cachee aunque cambie el código.
- `npm ci --omit=dev` instala solo dependencias de producción (más rápido y pequeño).
- `EXPOSE` solo documenta el puerto; la publicación real es con `-p` en `docker run`.
- Asegúrate de que `server.js` escucha en `0.0.0.0` (no solo `localhost`) o no será accesible desde el host.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY app/package.json app/package-lock.json ./
RUN npm ci --omit=dev
COPY app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
