# Error "command not found": PATH y resolución de comandos

El error más universal en Linux/macOS: escribes un comando y el shell dice que no lo encuentra.

## El error

```bash
$ node --version
bash: node: command not found

$ docker ps
zsh: command: not found: docker
```

O su prima hermana, la versión con número de error:

```bash
$ ionic serve
bash: ionic: command not found
```

## Causa

El shell no busca comandos en todo el disco. Solo busca en los directorios listados en la variable de entorno **`PATH`**. Si el ejecutable no está en ninguno de esos directorios, aparece "command not found".

```bash
# Ver tu PATH actual
echo $PATH
# /home/arcanis/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Separados:
printenv PATH | tr ':' '\n'
```

Cada entrada es un directorio donde el shell busca el ejecutable que escribes, **en orden**. Si hay dos `node` en distintos directorios, gana el primero del PATH.

## Diagnosticar dónde está el binario

```bash
# ¿Está instalado pero fuera del PATH?
which node          # ruta si está en PATH
whereis node        # busca en sitios habituales (bin, sbin, etc.)
type node           # cómo lo interpreta el shell (alias, función, binario)

# Buscar en disco
find / -name node -type f 2>/dev/null
find ~ -name node -type f 2>/dev/null
locate node | grep bin

# ¿Lo instaló npm/pip en un sitio raro?
ls ~/.local/bin
ls ~/.npm-global/bin
ls ~/go/bin
ls ~/.cargo/bin
ls ~/node_modules/.bin
```

Casos típicos donde aparece "command not found" aunque esté instalado:

| Herramienta | Suele instalarse en | ¿En PATH por defecto? |
|---|---|---|
| pip (`--user`) | `~/.local/bin` | ❌ a veces |
| npm global (sin sudo) | `~/.npm-global/bin` | ❌ |
| nvm Node | `~/.nvm/versions/node/vXX/bin` | ✅ (nvm lo añade) |
| Cargo (Rust) | `~/.cargo/bin` | ✅ (rustup lo añade) |
| Go binarios | `~/go/bin` | ❌ |
| Composer | `~/.composer/vendor/bin` | ❌ |
| Python venv | `venv/bin` | ✅ si está activado |

## Solución 1 — Añadir el directorio al PATH

La solución directa: añadir el directorio que contiene el binario al PATH.

### Temporal (solo esta sesión)

```bash
export PATH="$HOME/.local/bin:$PATH"
node --version   # ahora funciona
```

El cambio se pierde al cerrar la terminal.

### Permanente (recomendado)

Añade la línea a tu archivo de configuración del shell:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### ¿Qué archivo editar?

Depende del shell y del tipo de sesión:

| Shell | Archivo interactivo | Archivo de login |
|---|---|---|
| **bash** | `~/.bashrc` | `~/.bash_profile` (o `~/.profile`) |
| **zsh** | `~/.zshrc` | `~/.zprofile` |
| genérico | — | `~/.profile` |

- **Interactivo no-login** (abrir una terminal nueva en escritorio): lee `.bashrc`/`.zshrc`.
- **Login** (SSH, consola virtual): lee `.bash_profile`/`.zprofile`.
- Truco común: que `.bash_profile` cargue `.bashrc` para no duplicar.

```bash
# ~/.bash_profile
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
```

### Plantilla típica de `~/.bashrc`

```bash
# ~/.bashrc

# Herramientas de usuario
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Si usas nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

Tras editar:

```bash
source ~/.bashrc   # recargar sin reiniciar
```

## Solución 2 — El binario no tiene permiso de ejecución

A veces el archivo existe pero no es ejecutable:

```bash
$ ./miscript.sh
bash: ./miscript.sh: Permission denied
```

```bash
ls -l miscript.sh
# -rw-r--r-- 1 arcanis arcanis 120 ...   (falta la 'x')

chmod +x miscript.sh
ls -l miscript.sh
# -rwxr-xr-x 1 arcanis arcanis 120 ...
./miscript.sh   # funciona
```

## Solución 3 — Symlinks a `/usr/local/bin`

Si el binario está en un sitio raro y quieres que sea accesible globalmente:

```bash
# Crear un enlace simbólico en un directorio del PATH
sudo ln -s /opt/miapp/bin/app /usr/local/bin/app
app --version
```

```bash
# Verificar el enlace
ls -l /usr/local/bin/app
# lrwxrwxrwx ... /usr/local/bin/app -> /opt/miapp/bin/app

# Eliminarlo
sudo rm /usr/local/bin/app
```

> Recuerda que `/usr/local/bin` suele estar en el PATH de todos los usuarios.

## Solución 4 — `update-alternatives`

En Debian/Ubuntu, `update-alternatives` gestiona varios programas que cumplen la misma función (por ejemplo, varias versiones de `java`, `python`, `editor`).

```bash
# Ver las alternativas de un comando
update-alternatives --list editor
update-alternatives --display python3

# Registrar tu binario como una alternativa
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nano 50

# Elegir cuál usar de forma interactiva
sudo update-alternatives --config editor
sudo update-alternatives --config java

# Quitar una alternativa
sudo update-alternatives --remove editor /usr/bin/nano
```

El sistema crea symlinks en `/usr/bin/<comando>` apuntando a `/etc/alternatives/<comando>`, que a su vez apunta al binario elegido. Útil para cosas como Java, donde conviven JDKs de varios proveedores.

## Solución 5 — El paquete no está instalado

A veces "command not found" significa literalmente eso: no lo instalaste.

```bash
# Debian/Ubuntu
sudo apt install nodejs

# Fedora
sudo dnf install nodejs

# Arch
sudo pacman -S nodejs

# macOS
brew install node
```

Muchas distros incluyen un "command not found handler" que te sugiere el paquete:

```bash
$ htop
bash: htop: command not found
Install package 'htop' to provide command 'htop'? [N/y]
```

## Solución 6 — El comando es un alias o función

Un comando puede estar definido como alias o función del shell, y si abres otro shell (o `sh` en vez de `bash`) no lo tendrá.

```bash
type ll
# ll is aliased to 'ls -alF'

# Ver definición
alias ll
declare -f mi_funcion

# Los alias se cargan desde ~/.bashrc
# Si usas sudo, los alias no se heredan por defecto
alias sudo='sudo '   # el espacio final permite expandir alias tras sudo
```

## Solución 7 — Entornos virtuales (Python, Node, etc.)

Herramientas como venv, nvm, pyenv, rbenv activan/desactivan binarios cambiando el PATH. Si el comando "no funciona" puede que el entorno esté desactivado.

```bash
# Python venv
source venv/bin/activate       # activa: añade venv/bin al PATH
which python                   # .../venv/bin/python
deactivate                     # restaura PATH

# nvm
nvm use 20                     # cambia PATH a esa versión
nvm deactivate                  # lo quita
```

## Verificar la resolución de un comando

```bash
# Muestra exactamente qué se ejecutaría
which -a node        # todas las coincidencias en PATH (en orden)
command -v node       # más portable
type -a node          # incluye alias/funciones
```

Si `which -a node` muestra varios, el primero es el que se usa:

```bash
$ which -a node
/home/arcanis/.nvm/versions/node/v20.11.1/bin/node   # ← este se usa
/usr/bin/node                                         # ignorado
```

## Caso concreto: nvm dice "nvm: command not found"

`nvm` es una función del shell, no un binario. Se carga al sourcear `~/.nvm/nvm.sh`, normalmente desde `.bashrc`/`.zshrc`.

```bash
# Si no se cargó, cargalo a mano
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Verificar
type nvm
# nvm is a function
```

## Tabla resumen

| Situación | Solución |
|---|---|
| Binario en `~/.local/bin` | Añadir al PATH |
| Instalado por npm global | Añadir `~/.npm-global/bin` o usar nvm |
| Instalado por cargo | Añadir `~/.cargo/bin` |
| No tiene permiso `x` | `chmod +x archivo` |
| En ruta rara, global | `ln -s` a `/usr/local/bin` |
| Varias versiones (java, python) | `update-alternatives --config` |
| No instalado | `apt/dnf/pacman install` |
| Era un alias | Definirlo en `.bashrc`/`.zshrc` |
| venv desactivado | `source venv/bin/activate` |

## Checklist rápido

1. `echo $PATH` → ¿está el directorio del binario?
2. `which -a <comando>` → ¿aparece alguna ruta?
3. `ls -l <ruta>` → ¿tiene permiso de ejecución?
4. ¿Editaste `.bashrc` y hiciste `source`?
5. ¿Estás usando el mismo shell en el que configuraste todo?
