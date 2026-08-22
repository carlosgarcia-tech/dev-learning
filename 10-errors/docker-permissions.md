# Error de permisos de Docker: permission denied

El error clásico al instalar Docker en Linux: sin `sudo` no funciona.

## El error

```bash
$ docker ps
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
```

O al intentar ejecutar sin sudo:

```bash
$ docker run hello-world
docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/create": dial unix /var/run/docker.sock: connect: permission denied.
See 'docker run --help'.
```

## Causa

Docker funciona con cliente-servidor:

- El **daemon** (`dockerd`) corre como `root` y escucha en un socket Unix: `/var/run/docker.sock`.
- El **cliente** (`docker`) se conecta a ese socket.

El socket pertenece a `root:docker` con permisos `rw` para el grupo `docker`:

```bash
$ ls -l /var/run/docker.sock
srw-rw---- 1 root docker 0 ago 22 10:00 /var/run/docker.sock
```

Tu usuario solo podrá usarlo si está en el grupo `docker`. Si no, obtienes "permission denied".

```
Socket:    /var/run/docker.sock
Dueño:     root:docker
Permisos:  srw-rw----   (rw para root y grupo docker, nada para otros)
Tu user:   no está en grupo docker  →  permission denied
```

## ❌ Lo que NO debes hacer

### 1. Usar `sudo docker` para todo

Funciona, pero es molesto y tiene riesgos:

- Cada comando lleva `sudo`.
- Los volúmenes montados pueden acabar siendo de `root` y luego no puedes editarlos.

```bash
# ❌ Evitar como solución permanente
sudo docker ps
sudo docker run -v $(pwd):/app node npm install
# node_modules acaba siendo de root: luego no puedes borrarlo sin sudo
```

### 2. `chmod 777 /var/run/docker.sock`

```bash
# ❌ Inseguro: cualquier usuario del sistema podría controlar Docker
sudo chmod 777 /var/run/docker.sock
```

Y además el cambio **se pierde al reiniciar**, porque el socket lo recrea el daemon.

## ✅ Soluciones correctas

### Solución 1 — Añadir tu usuario al grupo `docker` (RECOMENDADA)

Es la solución oficial y la más cómoda para desarrollo local.

```bash
# 1. Crear el grupo (suele existir ya al instalar Docker)
sudo groupadd docker

# 2. Añadir tu usuario al grupo
sudo usermod -aG docker $USER

# 3. Aplicar el cambio sin cerrar sesión (en la shell actual)
newgrp docker

# 4. Probar
docker ps
docker run hello-world
```

> ⚠️ **Importante**: `usermod` no afecta a la sesión actual. Tienes que:
> - cerrar sesión y volver a entrar, **o**
> - reiniciar, **o**
> - ejecutar `newgrp docker` para abrir una subshell con el nuevo grupo.

Verifica que estás en el grupo:

```bash
groups                # ¿sale "docker"?
id -nG
getent group docker   # miembros del grupo
```

Si tras hacer todo esto sigue fallando, reinicia el daemon:

```bash
sudo systemctl restart docker
```

### Solución 2 — Reiniciar sesión / sistema

El cambio de grupo no surte efecto en sesiones ya abiertas. Si `newgrp docker` no te basta:

```bash
# Cerrar sesión gráfica y volver a entrar
# O reiniciar el sistema
sudo reboot
```

Tras reiniciar:

```bash
docker ps   # debería funcionar sin sudo
```

### Solución 3 — Comprobar el socket y el daemon

Si ya estás en el grupo pero sigue dando error, revisa el socket y el servicio:

```bash
# Estado del socket
ls -l /var/run/docker.sock
# srw-rw---- 1 root docker ...   ← el grupo debe ser "docker"

# Estado del daemon
sudo systemctl status docker
sudo systemctl restart docker

# ¿Está escuchando?
sudo ss -lx | grep docker.sock
```

### Solución 4 — `daemon.json` y permisos del socket

A veces la configuración del daemon cambia el socket o sus permisos. Revisa `/etc/docker/daemon.json`:

```json
{
  "data-root": "/var/lib/docker",
  "hosts": ["unix:///var/run/docker.sock"]
}
```

Si modificas el archivo, recarga la config y reinicia:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Para aplicar permisos concretos al socket en cada arranque (avanzado):

```json
{
  "group": "docker"
}
```

### Solución 5 — Rootless mode (sin root en el daemon)

El **rootless mode** ejecuta el daemon de Docker dentro de tu sesión de usuario, sin necesidad de `root` ni del grupo `docker`. Es la opción más segura y la recomendada en entornos multiusuario.

```bash
# 1. Instalar dependencias (Debian/Ubuntu)
sudo apt install uidmap

# 2. Habilitar linger para que el daemon arranque sin sesión abierta
sudo loginctl enable-linger $USER

# 3. Instalar rootless dockerd
dockerd-rootless-setuptool.sh install

# 4. Configurar variables de entorno
echo 'export DOCKER_HOST=unix:///run/user/$UID/docker.sock' >> ~/.bashrc
source ~/.bashrc

# 5. Arrancar el servicio de usuario
systemctl --user start docker
systemctl --user enable docker

# 6. Probar
docker ps
```

Ventajas del rootless mode:

- El daemon corre como tu usuario, no como `root`.
- No necesitas el grupo `docker` ni `sudo`.
- Un contenedor comprometido tiene menos privilegios.

Desventajas:

- Algunas funciones (ciertas redes, `--privileged` limitado) funcionan distinto.
- Requiere `slirp4netns` o `rootlesskit` para red.

## Comparativa de enfoques

| Método | Comodidad | Seguridad | Cuándo |
|---|---|---|---|
| `sudo docker ...` | ❌ Molesto | ⚠️ Media | Nunca como solución definitiva |
| Grupo `docker` | ✅✅ | ⚠️ Baja en shared | Desarrollo local personal |
| `chmod 777` socket | ❌ | ❌❌ | Nunca |
| **Rootless mode** | ✅ | ✅✅ | Multiusuario, producción sensible |

## ⚠️ Riesgo de seguridad del grupo `docker`

Estar en el grupo `docker` equivale **a ser `root`**. Cualquiera en ese grupo puede:

```bash
# Montar el disco raíz del host en un contenedor y leer/escribir todo
docker run -v /:/host -it ubuntu chroot /host
```

Por eso:

- En una máquina **personal** de desarrollo, el grupo `docker` es aceptable.
- En un **servidor compartido**, evita dar el grupo `docker` a usuarios no privilegiados. Usa rootless mode o limita con políticas adicionales.

## Otros errores relacionados

### "Cannot connect to the Docker daemon"

Si el daemon no está corriendo:

```bash
$ docker ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

### "docker.sock: no such file or directory"

El socket no existe porque el daemon no arrancó:

```bash
sudo systemctl status docker
sudo journalctl -u docker -n 50 --no-pager
sudo systemctl restart docker
```

### Permisos en bind mounts (archivos de root)

Si ejecutaste algo con `sudo docker` y se crearon archivos en tu host como `root`:

```bash
$ rm -rf node_modules
rm: cannot remove 'node_modules/foo': Permission denied

# Solución: cambiar el dueño de vuelta a tu usuario
sudo chown -R $USER:$USER node_modules
```

### Error de contexto remoto

Si `DOCKER_HOST` apunta a un sitio raro:

```bash
echo $DOCKER_HOST
# unix:///run/user/1000/docker.sock   ← rootless
unset DOCKER_HOST                      # para usar el socket por defecto
docker context use default
```

## Verificación final

```bash
# 1. Usuario en el grupo
groups | grep docker

# 2. Socket correcto
ls -l /var/run/docker.sock

# 3. Daemon activo
systemctl is-active docker

# 4. Todo funciona
docker info
docker run --rm hello-world
```

Si `docker run --rm hello-world` imprime "Hello from Docker!", el problema de permisos está resuelto.

## Resumen rápido

```bash
# Solución de un comando (la que funciona el 90% de las veces)
sudo usermod -aG docker $USER && newgrp docker
```

Reinicia sesión si `newgrp` no basta. Para entornos compartidos o sensibles, evalúa rootless mode.
