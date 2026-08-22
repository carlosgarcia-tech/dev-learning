# tmux y productividad

> tmux: sesiones, ventanas y paneles. SSH, ssh-agent y ssh config para trabajo remoto.

## ¿Qué es tmux?

**tmux** (terminal multiplexer) permite tener múltiples sesiones, ventanas y paneles en una sola terminal. Sus grandes ventajas:

- **Persistencia:** los procesos siguen corriendo aunque cierres la terminal o pierdas la conexión SSH.
- **Múltiples ventanas** y paneles en una sola pantalla.
- **Sesiones compartidas** entre conexiones.

```
+-------------------+-------------------+
|  ventana 0 / 0    |  ventana 0 / 1    |
|  pane1            |  pane2            |
|                   |                   |
+-------------------+-------------------+
|  ventana 0 / 2 (full)                |
+-------------------+-------------------+
```

## Instalación

```bash
# Debian/Ubuntu
sudo apt install tmux

# Fedora
sudo dnf install tmux

# macOS
brew install tmux

# Arch
sudo pacman -S tmux
```

```bash
tmux -V             # versión
```

## Conceptos

| Concepto | Qué es |
|----------|--------|
| **Server** | Proceso tmux que gestiona todo |
| **Session** | Espacio de trabajo con ventanas |
| **Window** | Como una pestaña: ocupa toda la pantalla |
| **Pane** | División dentro de una ventana |
| **Prefix** | La combinación que precede a los comandos tmux (por defecto `Ctrl+B`) |

## Sesiones

### Crear y gestionar

```bash
tmux                       # sesión nueva
tmux new -s trabajo         # sesión con nombre
tmux new -s trabajo -d      # detached (en background)
tmux ls                     # listar sesiones
tmux attach -t trabajo       # conectar a una sesión
tmux a -t trabajo            # abreviatura
tmux kill-session -t trabajo   # matar una sesión
tmux kill-server             # matar todo tmux
```

### Attach y detach

- **detach** (separarse): `Ctrl+B` y luego `D`. Sales de la sesión pero los procesos siguen corriendo.
- **attach** (reconectar): `tmux a -t nombre`.

```bash
tmux new -s server
# dentro: node server.js
# Ctrl+B D    -> detach
# los procesos siguen corriendo
tmux a -t server            # reconectar
```

## El prefix

Casi todos los comandos en tmux empiezan con el **prefix**: `Ctrl+B`. Se pulsa y suelta, y luego la tecla del comando.

```
Ctrl+B  (suelta)  c    -> crear ventana
Ctrl+B  (suelta)  %    -> dividir vertical
```

## Ventanas

| Atajo | Acción |
|-------|--------|
| `Ctrl+B c` | Crear ventana |
| `Ctrl+B ,` | Renombrar ventana |
| `Ctrl+B n` | Siguiente ventana |
| `Ctrl+B p` | Ventana anterior |
| `Ctrl+B 0-9` | Ir a ventana por número |
| `Ctrl+B &` | Cerrar ventana |
| `Ctrl+B w` | Lista interactiva de ventanas |
| `Ctrl+B f` | Buscar ventana por nombre |

## Paneles

| Atajo | Acción |
|-------|--------|
| `Ctrl+B %` | Dividir vertical (izq/der) |
| `Ctrl+B "` | Dividir horizontal (arriba/abajo) |
| `Ctrl+B ↑↓←→` | Mover el foco |
| `Ctrl+B o` | Rotar foco |
| `Ctrl+B z` | Zoom (full screen) del panel actual |
| `Ctrl+B x` | Cerrar panel |
| `Ctrl+B {` `}` | Intercambiar paneles |
| `Ctrl+B Ctrl+↑↓` | Redimensionar (con flechas) |
| `Ctrl+B Space` | Reorganizar layouts |

## Modo copia

Para copiar texto dentro de tmux:

1. `Ctrl+B [` entra en modo copia.
2. Navega con flechas o `Ctrl+Space` para iniciar selección (modo vi) o `Space` (modo emacs).
3. `Enter` copia la selección al buffer de tmux.
4. `Ctrl+B ]` pega.

### Modo vi

En `~/.tmux.conf`:

```
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -sel clip"
```

## Configuración (~/.tmux.conf)

Archivo de configuración que se carga al iniciar tmux.

```
# ~/.tmux.conf

# Cambiar prefix a Ctrl+A (más cómodo)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Empezar ventanas en 1 (no 0)
set -g base-index 1
setw -g pane-base-index 1

# Soporte 256 colores y truecolor
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Ratón: scroll, click para cambiar panel, redimensionar
set -g mouse on

# Vi mode
setw -g mode-keys vi

# Recargar config con r
bind r source-file ~/.tmux.conf \; display "Config recargada"

# Dividir con | y - (más intuitivo)
bind | split-window -h
bind - split-window -v

# Histórico más largo
set -g history-limit 50000

# Status bar personalizada
set -g status-bg colour235
set -g status-fg colour137
set -g status-left "#[fg=green]#S "
set -g status-right "#[fg=white]%Y-%m-%d %H:%M "
```

Recarga:

```bash
tmux source-file ~/.tmux.conf
# o dentro de tmux: Ctrl+B r (si lo configuraste)
```

## tmuxp y tmuxinator

Para gestionar sesiones complejas y reproducibles se usan herramientas de alto nivel:

### tmuxinator (Ruby)

```yaml
# ~/.config/tmuxinator/proyecto.yml
name: proyecto
windows:
  - editor:
      layout: main-vertical
      panes:
        - vim
        - guard
  - server: pnpm dev
  - logs: tail -f logs/app.log
  - db: psql myapp_dev
```

```bash
tmuxinator start proyecto
tmuxinator stop proyecto
```

### tmuxp (Python)

```yaml
# proyecto.yaml
session_name: proyecto
windows:
  - window_name: dev
    panes:
      - shell_command: vim
      - shell_command: pnpm dev
```

```bash
tmuxp load proyecto.yaml
```

## SSH

**SSH** (Secure Shell) permite ejecutar comandos en una máquina remota de forma segura.

### Conexión básica

```bash
ssh usuario@servidor.com
ssh -p 2222 usuario@servidor.com    # puerto distinto
```

### Ejecutar un comando remoto

```bash
ssh usuario@servidor "df -h"
ssh usuario@servidor "systemctl status nginx"
```

### Copiar archivos

```bash
# scp
scp archivo.txt usuario@servidor:/ruta/destino/
scp usuario@servidor:/ruta/remoto.txt ./
scp -r carpeta/ usuario@servidor:/ruta/

# rsync (más eficiente, reanudable)
rsync -avz carpeta/ usuario@servidor:/ruta/destino/
rsync -avz --delete carpeta/ usuario@servidor:/ruta/
```

### Claves SSH

La autenticación por clave evita escribir la contraseña y es más segura.

```bash
# Generar par de claves (ed25519, recomendado)
ssh-keygen -t ed25519 -C "tu@email.com"

# (RSA legacy, si hace falta)
ssh-keygen -t rsa -b 4096 -C "tu@email.com"
```

Esto crea:

- `~/.ssh/id_ed25519` (clave privada, NUNCA la compartas).
- `~/.ssh/id_ed25519.pub` (clave pública).

### Copiar la clave pública al servidor

```bash
ssh-copy-id usuario@servidor
```

Ahora puedes conectarte sin contraseña:

```bash
ssh usuario@servidor
```

### Permisos de las claves

SSH es estricto con los permisos:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

## ssh config

El archivo `~/.ssh/config` define alias y opciones para cada host.

```
# ~/.ssh/config

Host mi-servidor
  HostName 192.168.1.50
  User ada
  Port 2222
  IdentityFile ~/.ssh/id_ed25519
  ForwardAgent yes

Host github.com
  User git
  IdentityFile ~/.ssh/github_key

Host *.ejemplo.com
  User deploy
  ForwardAgent yes
```

Ahora:

```bash
ssh mi-servidor            # en vez de ssh -p 2222 ada@192.168.1.50
```

### Opciones útiles

| Opción | Para qué |
|--------|----------|
| `HostName` | IP o dominio |
| `User` | Usuario por defecto |
| `Port` | Puerto |
| `IdentityFile` | Clave a usar |
| `ForwardAgent` | Reenviar el agent (para git en remoto) |
| `LocalForward` | Túnel local |
| `ServerAliveInterval` | Keepalive para evitar desconexiones |
| `Compression` | Comprimir tráfico |

### Túneles SSH (port forwarding)

**Local:** exponer un puerto remoto en tu máquina.

```bash
ssh -L 8080:localhost:80 usuario@servidor
# ahora http://localhost:8080 en tu máquina accede al puerto 80 del servidor
```

**Remoto:** exponer un puerto local en el servidor.

```bash
ssh -R 9090:localhost:3000 usuario@servidor
# en el servidor, localhost:9090 accede a tu puerto 3000
```

**Dinámico (SOCKS proxy):**

```bash
ssh -D 1080 usuario@servidor
```

## ssh-agent

**ssh-agent** guarda las claves en memoria para no tener que escribir el passphrase cada vez.

```bash
eval "$(ssh-agent -s)"       # arrancar el agent
ssh-add ~/.ssh/id_ed25519     # añadir la clave
ssh-add -l                    # listar claves cargadas
ssh-add -D                    # borrar todas
```

### ForwardAgent

Permite usar tus claves locales desde una sesión SSH remota (útil para git en el servidor).

```
# ~/.ssh/config
Host mi-servidor
  ForwardAgent yes
```

```bash
# En el servidor remoto:
git clone git@github.com:...   # usa tu clave local, sin claves en el servidor
```

## tmux + SSH: el combo definitivo

Para trabajar en un servidor remoto de forma persistente:

```bash
# 1. Conectar por SSH
ssh mi-servidor

# 2. Crear o reconectar una sesión tmux
tmux a -t trabajo 2>/dev/null || tmux new -s trabajo

# 3. Trabajar, ejecutar procesos largos...
pnpm dev

# 4. Detach: Ctrl+B D
# Los procesos siguen corriendo aunque cierres la terminal o pierdas SSH

# 5. Reconectar más tarde
ssh mi-servidor
tmux a -t trabajo
```

### Atajo SSH + tmux

```
# ~/.ssh/config
Host dev
  HostName 192.168.1.50
  User ada
  RemoteCommand tmux a -t main 2>/dev/null || tmux new -s main
  RequestTTY yes
```

```bash
ssh dev             # conecta y entra directamente a la sesión tmux
```

## Otros multiplexores

| Herramienta | Notas |
|-------------|-------|
| **screen** | El predecesor de tmux, aún presente en sistemas antiguos |
| **zellij** | Moderno, Rust, muy amigable |
| **byobu** | Wrapper sobre tmux con configuración por defecto |

## Productividad con la terminal

### alias útiles

```bash
# ~/.bashrc o ~/.zshrc
alias ll='ls -lah'
alias gs='git status'
alias gd='git diff'
alias ..='cd ..'
alias ...='cd ../..'
alias ports='ss -tlnp'
alias myip='curl ifconfig.me'
alias reload='source ~/.bashrc'
```

### fzf (fuzzy finder)

```bash
# Instalar
sudo apt install fzf

# Buscar archivos
fzf                          # fuzzy finder interactivo
vim $(fzf)                   # abrir el archivo elegido

# Con git
git checkout $(git branch | fzf | tr -d ' ')

# Historial
history | fzf
```

Integración con shell: `Ctrl+R` para búsqueda difusa en el historial.

### starship prompt

Un prompt moderno y multi-shell:

```bash
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc
# o zsh
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
```

### zoxide

Salto inteligente de directorios basado en frecuencia:

```bash
zoxide install
z proyecto            # cd al directorio más usado llamado "proyecto"
zi proyecto           # selección interactiva
```

## Buenas prácticas

1. **Usa tmux para procesos largos** y sesiones SSH.
2. **Configura `~/.ssh/config`** con aliases para no recordar IPs y puertos.
3. **Usa claves ed25519** y `ssh-copy-id` para autenticarte sin contraseña.
4. **ForwardAgent** solo en hosts de confianza.
5. **Personaliza tu `.tmux.conf`** para que tmux se sienta natural.
6. **Aprende fzf**: cambia cómo buscas archivos y comandos.
7. **Usa `rsync` en lugar de `scp`** para sincronizar carpetas.

---

> Anterior: [Shell scripting](04-shell-scripting.md) · Volver al [índice](README.md)
