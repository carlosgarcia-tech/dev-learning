# Ejercicio 05 — Compose con nginx y backend

- **Nivel:** 4/5
- **Tema:** reverse proxy nginx, compose multi-servicio, configuración
- **Tiempo estimado:** 40 min

## Enunciado

Crea un `docker-compose.yml` con nginx como reverse proxy delante de un backend Node.

1. **`backend`**: `build: ./app`, no publica puertos al host (solo accesible dentro de la red).
2. **`proxy`**: imagen `nginx:1.27-alpine`, publica `8099:80`, monta `./nginx/default.conf` en `/etc/nginx/conf.d/default.conf`.
3. La config de nginx hace `proxy_pass http://backend:3000`.
4. Red de usuario `proxynet`.

## Requisitos

- [ ] Servicio `backend` con `build: ./app`
- [ ] `backend` **sin** `ports:` (solo dentro de la red)
- [ ] Servicio `proxy` con `nginx:1.27-alpine`
- [ ] `proxy` publica `8099:80`
- [ ] `proxy` monta `./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro`
- [ ] Config de nginx con `proxy_pass http://backend:3000`
- [ ] Red `proxynet`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- nginx resuelve `backend` por el DNS interno de Docker.
- `proxy_pass http://backend:3000;` reenvía al servicio `backend` en el puerto 3000.
- El backend no necesita `ports:` porque nginx accede por la red interna.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  proxy:
    image: nginx:1.27-alpine
    ports:
      - "8099:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on: [backend]
    networks: [proxynet]

  backend:
    build: ./app
    networks: [proxynet]

networks:
  proxynet:
```

`nginx/default.conf`:

```nginx
server {
  listen 80;
  location / {
    proxy_pass http://backend:3000;
    proxy_set_header Host $host;
  }
}
```

</details>
