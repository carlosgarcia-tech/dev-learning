# Ejercicio 02 — depends_on y healthcheck

- **Nivel:** 3/5
- **Tema:** `depends_on` con condición, `healthcheck` propio de la app
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `docker-compose.yml` donde una app Node expone su propio `/health` y tiene un `healthcheck` declarado, y un servicio "reporter" que depende de que la app esté `healthy` antes de arrancar.

1. **`app`**: `build: ./app`, expone `/health` (`{"ok":true}`), tiene un `healthcheck` con `wget` a `http://localhost:3000/health`, publica `8092:3000`.
2. **`reporter`**: imagen `alpine:3.20`, depende de `app` con `condition: service_healthy`, y al arrancar hace `wget` a `http://app:3000/health` y muestra el resultado.

## Requisitos

- [ ] Servicio `app` con `healthcheck` declarado (test, interval, timeout, retries)
- [ ] `healthcheck` consulta `http://localhost:3000/health`
- [ ] Servicio `reporter` con `depends_on: app: condition: service_healthy`
- [ ] `reporter` usa `wget` hacia `http://app:3000/health`
- [ ] `app` publica `8092:3000`
- [ ] Red de usuario entre ambos
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `wget -qO- http://localhost:3000/health` devuelve 0 si la app responde 200.
- `condition: service_healthy` hace que `reporter` no arranque hasta que `app` esté `healthy`.
- `reporter` puede usar `command: ["sh","-c","wget -qO- http://app:3000/health"]` para ejecutar al arrancar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  app:
    build: ./app
    ports:
      - "8092:3000"
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:3000/health || exit 1"]
      interval: 10s
      timeout: 3s
      retries: 5
      start_period: 5s
    networks: [appnet]

  reporter:
    image: alpine:3.20
    depends_on:
      app:
        condition: service_healthy
    command: ["sh", "-c", "wget -qO- http://app:3000/health && echo OK"]
    networks: [appnet]

networks:
  appnet:
```

</details>
