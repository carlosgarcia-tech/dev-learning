# Ejercicio 04 — Red entre dos contenedores

- **Nivel:** 2/5
- **Tema:** redes de usuario, DNS interno, comunicación entre contenedores
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `docker-compose.yml` con dos servicios que se comunican por una red de usuario:

1. **`api`**: app Node que responde `{"ok":true,"from":"api"}` y, en `/proxy`, consulta a `http://backend:3000` y devuelve su respuesta.
2. **`backend`**: app Node simple que responde `{"ok":true,"from":"backend"}`.
3. Ambos servicios en una red de usuario llamada `appnet`.
4. `api` publica el puerto `8090:3000`.

El DNS interno de Docker resuelve `backend` a la IP del contenedor backend.

## Requisitos

- [ ] `docker-compose.yml` con dos servicios (`api` y `backend`)
- [ ] Una red `appnet` definida en la sección top-level `networks:`
- [ ] Ambos servicios se conectan a `appnet`
- [ ] `api` publica `8090:3000`
- [ ] `backend` **no** publica puertos al host (solo accesible dentro de la red)
- [ ] El código de `api` consulta a `http://backend:3000` (DNS por nombre de servicio)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En una red de usuario, Docker añade DNS interno: el nombre del servicio (`backend`) resuelve a la IP del contenedor.
- `backend` no necesita `ports:` porque solo se accede desde dentro de la red.
- `api` usa `http.get("http://backend:3000/health")` (Node stdlib) para llamar al backend.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  api:
    build: ./app-api
    ports:
      - "8090:3000"
    depends_on: [backend]
    networks: [appnet]

  backend:
    build: ./app-backend
    networks: [appnet]

networks:
  appnet:
    driver: bridge
```

</details>
