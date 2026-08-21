# 03 — Contenedores y redes

## Objetivos

- [ ] Dominar `docker run` con opciones `-d -p -v -e --name --rm --restart`
- [ ] Gestionar contenedores con `exec` `logs` `ps` `stop` `rm` `inspect` `stats`
- [ ] Diferenciar y usar volúmenes (named), bind mounts y `tmpfs`
- [ ] Conocer las redes `bridge` (por defecto), `host`, `none` y redes de usuario
- [ ] Entender el DNS interno de Docker y la comunicación entre contenedores
- [ ] Publicar puertos y diferenciar `-p` de `-P`
- [ ] Pasar variables de entorno con `-e` y archivos con `--env-file`
- [ ] Aplicar restart policies (`no`, `always`, `unless-stopped`, `on-failure`)

## Apuntes

### docker run — opciones principales

```bash
docker run [OPCIONES] IMAGEN [CMD] [args...]
```

| Opción | Significado |
|---|---|
| `-d` | Detached: corre en segundo plano, devuelve el ID |
| `-p HOST:CONT` | Publica un puerto del contenedor en el host |
| `-P` | Publica todos los puertos `EXPOSE` en puertos aleatorios del host |
| `-v VOL:/path` o `-v /host:/path` | Monta un volumen o un bind mount |
| `--mount type=...,source=...,target=...` | Sintaxis explícita (preferida para scripts) |
| `-e VAR=valor` | Variable de entorno |
| `--env-file .env` | Lee variables de un archivo |
| `--name web` | Nombre del contenedor (único) |
| `--rm` | Elimina el contenedor al terminar |
| `--restart unless-stopped` | Política de reinicio |
| `-w /app` | WORKDIR para el comando |
| `--network mi_red` | Red a la que se conecta |
| `--user 1000:1000` | UID:GID con el que corre |
| `--memory 512m --cpus 1.5` | Límites de recursos |
| `-it` | Interactivo + TTY (para shells) |
| `--health-cmd "..."` | Healthcheck en run |

Ejemplos:

```bash
# Servidor nginx en background, puerto 8080 del host → 80 del contenedor
docker run -d -p 8080:80 --name web --restart unless-stopped nginx:1.27-alpine

# App Node con bind mount del código y entorno
docker run -it --rm \
  -v "$PWD:/app" -w /app \
  -e NODE_ENV=development \
  node:20-alpine npm run dev

# Shell dentro de un Alpine
docker run -it --rm alpine:3.20 sh

# Ejecutar un comando puntual dentro de una imagen
docker run --rm alpine:3.20 echo "hola"
```

### Gestión de contenedores

```bash
docker ps                       # contenedores en ejecución
docker ps -a                    # todos (incluidos exited)
docker ps -q                    # solo IDs
docker ps --filter "name=web"   # por nombre
docker ps --format '{{.Names}}\t{{.Status}}\t{{.Ports}}'

docker logs web                 # stdout/stderr del contenedor
docker logs -f web              # follow (tail)
docker logs --tail 50 web       # últimas 50 líneas
docker logs -t web              # con timestamps

docker exec -it web sh          # abrir shell en el contenedor en marcha
docker exec web ls /app         # ejecutar comando sin TTY

docker stop web                 # SIGTERM, espera 10s, luego SIGKILL
docker stop -t 30 web           # tiempo de gracia 30s
docker kill web                 # SIGKILL inmediato
docker restart web

docker rm web                   # eliminar (debe estar parado)
docker rm -f web                # forzar parada + borrado
docker container prune          # borrar todos los parados

docker inspect web              # JSON con toda la metadata
docker inspect --format '{{.State.Status}}' web
docker inspect --format '{{.NetworkSettings.IPAddress}}' web

docker stats                    # CPU/memoria/red en vivo
docker stats --no-stream        # una sola lectura

docker top web                  # procesos del contenedor
docker diff web                  # cambios en el FS respecto a la imagen
```

### Volúmenes y bind mounts

| Tipo | Sintaxis `-v` | `--mount` | Persiste | Caso de uso |
|---|---|---|---|---|
| Named volume | `-v mis_datos:/data` | `type=volume,source=mis_datos,target=/data` | Sí (gestiona Docker) | BBDD, datos de app |
| Anonymous volume | `-v /data` | `type=volume,target=/data` | Sí (hash) | Raramente útil |
| Bind mount | `-v /host:/data` | `type=bind,source=/host,target=/data` | Sí (en el host) | Desarrollo (código en caliente) |
| tmpfs | `--tmpfs /data` | `type=tmpfs,target=/data` | No (RAM) | Secretos, estado efímero |

```bash
# Crear un volumen gestionado
docker volume create mis_datos
docker volume ls
docker volume inspect mis_datos
docker volume rm mis_datos

# Usarlo
docker run -d -v mis_datos:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret mysql:8

# Bind mount para desarrollo (código del host visible en el contenedor)
docker run -it --rm -v "$PWD:/app" -w /app node:20-alpine npm run dev

# tmpfs para datos efímeros en RAM
docker run --rm --tmpfs /cache alpine df -h /cache
```

> **Advertencia de permisos en bind mounts:** si el contenedor corre como root y escribe en el bind mount, los archivos del host serán propiedad de root. Si el contenedor corre como UID 1000, escribe como ese UID. Sincroniza el UID del host con el del contenedor para evitar "permission denied".

### Redes

Docker crea tres redes por defecto al instalar:

```bash
docker network ls
# NETWORK ID   NAME      DRIVER    SCOPE
# ...          bridge    bridge    local   ← por defecto
# ...          host      host      local   ← sin aislamiento de red
# ...          none      null      local   ← sin red
```

| Red | Driver | Comportamiento |
|---|---|---|
| `bridge` | bridge | Red virtual aislada con NAT. Los contenedores salen a internet vía NAT del host. |
| `host` | host | El contenedor usa la pila de red del host directamente (sin NAT, sin aislamiento). |
| `none` | null | Solo loopback. Sin red. |
| (user) | bridge | Red bridge de usuario, con DNS interno, mejor aislamiento y configuración. |

**Red bridge por defecto (`bridge`):** útil para pruebas, pero **no tiene DNS interno** entre contenedores por nombre; hay que enlazarlos con `--link` (obsoleto). Para producción/desarrollo, crea tu propia red:

```bash
docker network create mi_red
docker run -d --name db --network mi_red -e POSTGRES_PASSWORD=secret postgres:16
docker run -d --name app --network mi_red -e DB_HOST=db myapp:1.0
# Desde app, "db" resuelve por DNS interno de Docker a la IP del contenedor db
docker run --rm --network mi_red alpine ping -c2 db
```

> **DNS interno:** en una red **de usuario**, Docker arranca un DNS embebido (127.0.0.11) que resuelve los nombres de los contenedores a su IP. En la red `bridge` por defecto esto **no** funciona; por eso siempre se recomiendan redes de usuario.

**Red host:**

```bash
docker run -d --network host nginx:1.27
# nginx escucha directamente en el puerto 80 del host; no hace falta -p
```

> `host` solo funciona en Linux. En macOS/Windows la red del host es la de la VM de Docker, no la del ordenador.

**Red none:**

```bash
docker run --rm --network none alpine ip addr   # solo lo (loopback)
```

### Publicación de puertos

- `-p HOST:CONT` expone el puerto del contenedor en el host.
- `-P` (mayúscula) publica todos los `EXPOSE` en puertos efímeros del host (49152–65535).
- Se puede acotar la IP del host: `-p 127.0.0.1:8080:80` (solo localhost).
- Protocolo: `-p 8080:80/tcp` o `-p 5353:5353/udp`.

```bash
docker run -d -p 8080:80 nginx                  # 0.0.0.0:8080 → 80
docker run -d -p 127.0.0.1:8080:80 nginx        # solo localhost
docker run -d -P nginx                          # puertos aleatorios
docker port web                                 # muestra el mapeo
```

### Variables de entorno

```bash
docker run -e API_KEY=1234 -e DEBUG=true myapp
docker run --env-file .env myapp               # .env con VAR=valor por línea
docker run -e API_KEY myapp                     # hereda del shell actual
```

`.env`:

```
DB_HOST=db
DB_PORT=5432
DB_USER=app
DB_PASSWORD=secret
```

> Los secretos en `-e` son visibles con `docker inspect` y en `docker history` del contenedor. Para secretos reales usa Docker secrets (Swarm) o archivos montados.

### Restart policies

```bash
docker run -d --restart unless-stopped nginx
```

| Política | Comportamiento |
|---|---|
| `no` | (por defecto) No reinicia. |
| `always` | Reinicia siempre que pare (incluso si `exit 0`). |
| `unless-stopped` | Reinicia siempre, salvo si el usuario lo paró con `docker stop`. |
| `on-failure[:N]` | Reinicia solo si el proceso sale con código ≠ 0; máximo N intentos. |

Diferencia crítica `always` vs `unless-stopped`: si reinicias el host, con `always` el contenedor arranca de nuevo aunque lo hubieras parado; con `unless-stopped` respeta el stop manual.

## Tablas de referencia

### Opciones de `docker run` más usadas

| Opción | Ejemplo | Para qué |
|---|---|---|
| `-d` | `-d` | Background |
| `-it` | `-it` | Interactivo con TTY |
| `-p` | `-p 8080:80` | Publicar puerto |
| `-P` | `-P` | Publicar todos los EXPOSE |
| `-v` | `-v mis_datos:/data` | Volumen/bind |
| `--mount` | `--mount type=bind,source=.,target=/app` | Montaje explícito |
| `-e` | `-e NODE_ENV=prod` | Env var |
| `--env-file` | `--env-file .env` | Env desde archivo |
| `--name` | `--name web` | Nombre |
| `--rm` | `--rm` | Borrar al terminar |
| `--restart` | `--restart unless-stopped` | Política reinicio |
| `--network` | `--network mi_red` | Red |
| `--user` | `--user 1000:1000` | UID:GID |
| `-w` | `-w /app` | Working dir |
| `--memory` | `--memory 512m` | Límite memoria |
| `--cpus` | `--cpus 1.5` | Límite CPU |
| `--health-cmd` | `--health-cmd "curl -f http://localhost"` | Healthcheck |

### Comandos de gestión

| Comando | Acción |
|---|---|
| `docker ps` | Lista contenedores en marcha |
| `docker ps -a` | Todos |
| `docker logs [-f] [-n N]` | Logs |
| `docker exec -it <c> sh` | Shell dentro |
| `docker stop [-t N] <c>` | Parar (graceful) |
| `docker kill <c>` | Matar (inmediato) |
| `docker rm [-f] <c>` | Eliminar |
| `docker restart <c>` | Reiniciar |
| `docker inspect <c>` | Metadata JSON |
| `docker stats` | Recursos en vivo |
| `docker top <c>` | Procesos |
| `docker diff <c>` | Cambios en FS |
| `docker cp <c>:/path ./` | Copiar del contenedor al host |
| `docker cp ./ <c>:/path` | Copiar del host al contenedor |

### Tipos de montaje

| Tipo | `type=` | Persiste | Dónde vive | Usar para |
|---|---|---|---|---|
| Volume (named) | `volume` | Sí | `/var/lib/docker/volumes` | Datos de BBDD, estado |
| Bind mount | `bind` | Sí | Path del host | Desarrollo (código) |
| tmpfs | `tmpfs` | No | RAM | Secretos efímeros, cache |

## Conceptos clave

- **Container** = instancia en ejecución de una imagen; efímera por diseño.
- **Bind mount** = montaje de un path del host; ideal para desarrollo en caliente, pero acopla el contenedor al host.
- **Named volume** = volumen gestionado por Docker; portátil y desacoplado del host. El preferido para datos persistentes en producción.
- **tmpfs** = montaje en RAM; no persistente; útil para secretos o cache efímera.
- **Red bridge de usuario** = red aislada con DNS interno; la opción por defecto paraapps con varios contenedores.
- **DNS interno (127.0.0.11)** = el resolver que Docker incrusta en cada red de usuario; resuelve nombres de contenedores.
- **NAT** = en la red bridge, el contenedor sale a internet traducido por el host con NAT.
- **Publicación de puertos (`-p`)** = hacer accesible un puerto del contenedor desde fuera del host.
- **Restart policy** = qué hace Docker cuando el proceso principal del contenedor termina.
- **Detached (`-d`)** = el contenedor corre en background; la CLI devuelve el ID.

## Errores comunes

- **`bind: address already in use`**: el puerto del host ya está ocupado. Cambia el puerto del host (`-p 8081:80`) o libera el que ocupa (otro nginx, Apache, etc.).
- **`Container name already in use`**: ya existe un contenedor con ese nombre. Usa `--rm` para que se borre al terminar, o `docker rm -f <nombre>` antes.
- **No se ven entre sí dos contenedores por nombre**: están en la red `bridge` por defecto, que no tiene DNS por nombre. Crea una red de usuario con `docker network create` y conecta ambos.
- **`docker exec` sin `-it`**: se ejecuta pero no hay TTY; los comandos interactivos fallan. Usa `docker exec -it`.
- **Datos que desaparecen al borrar el contenedor**: no montaste un volumen. La container layer se pierde con `docker rm`.
- **`permission denied` en bind mount**: el UID del proceso del contenedor no tiene permisos sobre el directorio del host. Asegura el propietario o usa el mismo UID.
- **`-e VAR` sin valor hereda del shell**: si la variable no existe en el shell, se pasa vacía. Usa `--env-file` para que sea explícito.
- **`always` reinicia tras reboot aunque lo paraste**: usa `unless-stopped` si quieres respetar los stops manuales.
- **Confundir `host` y `bridge`**: en `host` no hace falta `-p` (los puertos son del host), pero pierdes aislamiento y no funciona en macOS/Windows igual.
- **`docker stop` tarda 10s**: porque la app no maneja SIGTERM. Usa `CMD`/`ENTRYPOINT` en forma exec o `exec` en scripts shell para que la señal llegue al proceso.
- **Montar el socket `/var/run/docker.sock`**: es root del host dentro del contenedor. Solo hazlo si confías plenamente en la imagen.
- **`docker logs` vacío**: la app escribe a un archivo en lugar de stdout/stderr. En contenedores, escribe SIEMPRE a stdout/stderr para que los logs los gestione Docker.
