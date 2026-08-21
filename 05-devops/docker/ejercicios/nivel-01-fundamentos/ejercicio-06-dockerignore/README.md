# Ejercicio 06 — .dockerignore

- **Nivel:** 1/5
- **Tema:** `.dockerignore`, contexto de build, optimización
- **Tiempo estimado:** 20 min

## Enunciado

La carpeta del ejercicio contiene archivos que **no** deben entrar en el contexto de build: `node_modules`, `.git`, logs, archivos de IDE, y un archivo `secrets.env` con credenciales. Crea un `.dockerignore` completo y un `Dockerfile` que copia `app/` y funciona.

1. Crea un `.dockerignore` que excluya como mínimo: `node_modules`, `.git`, `*.log`, `.env`, `secrets.env`, `.vscode`, `.idea`, `Dockerfile*`, `.dockerignore`, `solucion/`.
2. Crea un `Dockerfile` basado en `node:20-alpine` que copie `app/` y ejecute `node server.js`.

El objetivo es entender que `.dockerignore` reduce el contexto de build y evita filtrar secretos.

## Requisitos

- [ ] Existe `.dockerignore`
- [ ] `.dockerignore` excluye `node_modules`
- [ ] `.dockerignore` excluye `.git`
- [ ] `.dockerignore` excluye `*.log`
- [ ] `.dockerignore` excluye `secrets.env`
- [ ] `.dockerignore` excluye `.env`
- [ ] `.dockerignore` excluye `Dockerfile*`
- [ ] Existe `Dockerfile` con `FROM node:20-alpine` y `CMD ["node", "server.js"]`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `.dockerignore` usa sintaxis tipo `.gitignore`: patrones por línea.
- Puedes usar comodines: `*.log`, `Dockerfile*`.
- Excluir `Dockerfile*` y `.dockerignore` a sí mismos es buena práctica (no los necesitas dentro de la imagen).
- `secrets.env` y `.env` deben estar fuera del contexto para que no acaben en una capa.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`.dockerignore`:

```
node_modules
.git
.gitignore
*.log
.env
.env.*
secrets.env
.vscode
.idea
Dockerfile*
.dockerignore
coverage
dist
build
solucion/
*.md
```

`Dockerfile`:

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY app/package.json ./
RUN npm ci --omit=dev
COPY app/ ./
EXPOSE 3000
CMD ["node", "server.js"]
```

</details>
