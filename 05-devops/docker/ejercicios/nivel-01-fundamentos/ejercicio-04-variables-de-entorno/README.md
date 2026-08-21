# Ejercicio 04 — Variables de entorno

- **Nivel:** 1/5
- **Tema:** `ENV`, `-e` en run, app Node que lee `process.env`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un `Dockerfile` para una app Node que lee su configuración de variables de entorno.

1. Base `node:20-alpine`.
2. `WORKDIR /app`.
3. Define una variable por defecto con `ENV PORT=3000` y `ENV NODE_ENV=production`.
4. Copia `app/package.json` y ejecuta `npm ci --omit=dev`.
5. Copia el código de `app/`.
6. `EXPOSE 3000`.
7. `CMD ["node", "server.js"]`.

La app lee `process.env.PORT` y `process.env.NODE_ENV`. Al ejecutar `docker run -e PORT=4000 -p 4000:4000 <imagen>`, la app debe escuchar en el 4000.

## Requisitos

- [ ] `FROM node:20-alpine`
- [ ] `WORKDIR /app`
- [ ] `ENV PORT=3000` y `ENV NODE_ENV=production`
- [ ] `RUN npm ci --omit=dev` (con `package.json` copiado antes)
- [ ] `COPY app/ ./`
- [ ] `EXPOSE 3000`
- [ ] `CMD ["node", "server.js"]`
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `ENV PORT=3000` define un valor por defecto que `process.env.PORT` leerá dentro del contenedor.
- Con `-e PORT=4000` en `docker run` se sobrescribe el `ENV` por defecto.
- `ENV` admite varias variables en una sola instrucción: `ENV PORT=3000 NODE_ENV=production`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine
ENV PORT=3000 NODE_ENV=production
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
