# Ejercicio 04 — Red personalizada

- **Nivel:** 3/5
- **Tema:** redes de usuario, subred, alias DNS, red `internal`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `docker-compose.yml` con una red de usuario personalizada y alias DNS para los servicios.

1. Define una red `appnet` con driver `bridge` y subred `172.28.0.0/16`.
2. Servicio `web`: imagen `nginx:1.27-alpine`, puerto `8094:80`, alias DNS `frontend` en la red `appnet`.
3. Servicio `api`: `build: ./app`, puerto `8095:3000`, alias DNS `backend` en la red `appnet`.
4. Una segunda red `dbnet` marcada como `internal: true` (sin salida a internet) para aislar una futura BBDD.

## Requisitos

- [ ] Red `appnet` con `driver: bridge` y `ipam.config.subnet: 172.28.0.0/16`
- [ ] Red `dbnet` con `internal: true`
- [ ] `web` con alias `frontend` en `appnet`
- [ ] `api` con alias `backend` en `appnet`
- [ ] `web` publica `8094:80`
- [ ] `api` publica `8095:3000`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `networks.<nombre>.ipam.config.subnet` define la subred.
- Los alias se declaran en el servicio: `networks: appnet: aliases: [frontend]`.
- `internal: true` crea una red sin routeo a internet (solo intra-red).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
services:
  web:
    image: nginx:1.27-alpine
    ports:
      - "8094:80"
    networks:
      appnet:
        aliases: [frontend]

  api:
    build: ./app
    ports:
      - "8095:3000"
    networks:
      appnet:
        aliases: [backend]

networks:
  appnet:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
  dbnet:
    internal: true
```

</details>
