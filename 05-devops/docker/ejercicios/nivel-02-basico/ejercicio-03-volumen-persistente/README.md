# Ejercicio 03 — Volumen persistente

- **Nivel:** 2/5
- **Tema:** named volumes, persistencia de datos
- **Tiempo estimado:** 25 min

## Enunciado

Crea un `Dockerfile` para una app Node que escribe datos en un archivo dentro de `/app/data`, y configura el contenedor para que ese directorio sea un **volumen persistente** gestionado por Docker.

1. Base `node:20-alpine`.
2. `WORKDIR /app`.
3. Copia `app/` y ejecuta `node server.js`.
4. Declara `VOLUME ["/app/data"]` en el Dockerfile (documenta el punto de montaje).
5. La app escribe un contador en `/app/data/counter.json` en cada petición.

Al ejecutar `docker run -v mis_datos:/app/data ...`, reiniciar el contenedor debe conservar el contador.

## Requisitos

- [ ] `FROM node:20-alpine`
- [ ] `WORKDIR /app`
- [ ] `COPY app/ ./`
- [ ] `VOLUME ["/app/data"]` declarado en el Dockerfile
- [ ] `CMD ["node", "server.js"]`
- [ ] La app escribe en `/app/data/counter.json`
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `VOLUME ["/app/data"]` en el Dockerfile crea un volumen anónimo por defecto si no se especifica `-v`.
- En `docker run -v mis_datos:/app/data ...` montas un named volume sobre ese path.
- La app debe crear el directorio `/app/data` si no existe (`fs.mkdirSync(..., {recursive:true})`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
VOLUME ["/app/data"]
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
