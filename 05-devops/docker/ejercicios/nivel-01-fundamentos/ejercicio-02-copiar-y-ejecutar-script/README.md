# Ejercicio 02 — Copiar y ejecutar un script

- **Nivel:** 1/5
- **Tema:** `COPY`, `RUN chmod`, `ENTRYPOINT`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un `Dockerfile` que copie el script `app/hello.sh` al contenedor y lo ejecute al arrancar.

1. Base `alpine:3.20`.
2. Crea un `WORKDIR /app`.
3. Copia `app/hello.sh` a `/app/hello.sh` con `COPY`.
4. Dale permisos de ejecución con `RUN chmod +x /app/hello.sh`.
5. Usa `ENTRYPOINT ["/app/hello.sh"]`.

Al ejecutar `docker run <imagen>` debe imprimir el mensaje del script.

## Requisitos

- [ ] `FROM alpine:3.20`
- [ ] `WORKDIR /app`
- [ ] `COPY app/hello.sh /app/hello.sh` (o `COPY app/hello.sh .` dentro del WORKDIR)
- [ ] `RUN chmod +x /app/hello.sh`
- [ ] `ENTRYPOINT ["/app/hello.sh"]` en forma exec
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `WORKDIR /app` crea el directorio si no existe y establece el cwd.
- `COPY app/hello.sh .` copia dentro del WORKDIR actual (`.` = `/app`).
- `RUN chmod +x /app/hello.sh` hace el script ejecutable.
- `ENTRYPOINT` en forma exec garantiza que el script reciba señales correctamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM alpine:3.20
WORKDIR /app
COPY app/hello.sh .
RUN chmod +x /app/hello.sh
ENTRYPOINT ["/app/hello.sh"]
```

</details>
