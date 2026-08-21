# Ejercicio 05 — Registry privado

- **Nivel:** 5/5
- **Tema:** registry:2, push/pull a registry local, tagging
- **Tiempo estimado:** 35 min

## Enunciado

Crea un `docker-compose.yml` que levante un registry privado (`registry:2`) y un script `push.sh` que etiquete y suba una imagen.

1. `docker-compose.yml` con servicio `registry`: imagen `registry:2`, puerto `5000:5000`, volumen `registry_data:/var/lib/registry`.
2. `push.sh`: construye la app, etiqueta como `localhost:5000/miapp:1.0` y hace `docker push localhost:5000/miapp:1.0`.

## Requisitos

- [ ] `docker-compose.yml` con servicio `registry`
- [ ] `registry` usa `registry:2`
- [ ] `registry` publica `5000:5000`
- [ ] Volumen `registry_data` montado en `/var/lib/registry`
- [ ] `push.sh` etiqueta la imagen como `localhost:5000/miapp:1.0`
- [ ] `push.sh` hace `docker push`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El registry local en `localhost:5000` funciona sin TLS (es HTTP plano); Docker lo permite en localhost.
- `docker tag <imagen> localhost:5000/miapp:1.0` crea el alias para el registry.
- Para un registry en otro host sin TLS, hay que añadirlo a `/etc/docker/daemon.json` como `insecure-registries`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`docker-compose.yml`:

```yaml
services:
  registry:
    image: registry:2
    ports:
      - "5000:5000"
    volumes:
      - registry_data:/var/lib/registry
    restart: unless-stopped

volumes:
  registry_data:
```

`push.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
docker build -t miapp:1.0 ./app
docker tag miapp:1.0 localhost:5000/miapp:1.0
docker push localhost:5000/miapp:1.0
echo "OK: imagen subida a registry privado"
```

</details>
