# Ejercicio 01 — Primer Dockerfile

- **Nivel:** 1/5
- **Tema:** Dockerfile básico, `FROM`, `RUN`, `CMD`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un `Dockerfile` que construya una imagen a partir de `alpine:3.20` que:

1. Use `alpine:3.20` como imagen base.
2. Instale `curl` con `apk add --no-cache curl`.
3. Defina como comando por defecto `echo "Hola Docker"` (forma exec).

El resultado de `docker run <imagen>` debe imprimir `Hola Docker`.

## Requisitos

- [ ] El `Dockerfile` usa `FROM alpine:3.20`.
- [ ] Instala `curl` con `apk add --no-cache curl` en un solo `RUN`.
- [ ] Define `CMD` en forma exec: `CMD ["echo", "Hola Docker"]`.
- [ ] Existe un `.dockerignore` en la carpeta.
- [ ] Los tests pasan: `bash test.sh`

> **Cómo ejecutar los tests**
>
> ```bash
> bash test.sh
> ```
>
> Devuelve `0` si pasan y `1` si falla alguno. Si `hadolint` está instalado lo usa; si no, valida la sintaxis con `grep`/`awk`. Si Docker está disponible, construye y ejecuta la imagen.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La primera instrucción debe ser `FROM alpine:3.20`.
- Para instalar paquetes en Alpine: `RUN apk add --no-cache curl`.
- La forma exec usa JSON: `CMD ["echo", "Hola Docker"]` (con corchetes y comillas).
- `.dockerignore` puede tener al menos `*.md` y `.git`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM alpine:3.20
RUN apk add --no-cache curl
CMD ["echo", "Hola Docker"]
```

</details>
