# Ejercicio 04 — Logging driver

- **Nivel:** 4/5
- **Tema:** `logging`, drivers, rotación de logs (`max-size`, `max-file`)
- **Tiempo estimado:** 30 min

## Enunciado

Crea un `docker-compose.yml` que configure el logging driver `json-file` con rotación para una app Node.

1. Servicio `app` con `build: ./app`, puerto `8098:3000`.
2. `logging.driver: json-file`.
3. `logging.options.max-size: "10m"` (cada archivo de log máx 10 MB).
4. `logging.options.max-file: "3"` (máximo 3 archivos rotados).

La app escribe logs en stdout (para que Docker los capture) y debe responder en `/health`.

## Requisitos

- [ ] Servicio `app` con `build: ./app`
- [ ] `logging.driver: json-file`
- [ ] `logging.options` con `max-size: "10m"`
- [ ] `logging.options` con `max-file: "3"`
- [ ] `app` publica `8098:3000`
- [ ] La app escribe en stdout (`console.log`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En Compose, `logging:` es una clave del servicio: `logging: { driver: json-file, options: { max-size: "10m", max-file: "3" } }`.
- La app debe escribir en stdout/stderr; Docker captura esos streams.
- Sin rotación, `json-file` crece indefinidamente y puede llenar el disco.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
services:
  app:
    build: ./app
    ports:
      - "8098:3000"
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

</details>
