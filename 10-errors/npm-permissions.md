# Error EACCES de npm: permisos globales

Uno de los errores más comunes al empezar con Node.js/npm en Linux/macOS.

## El error

Al instalar un paquete de forma global (`npm install -g <paquete>`) aparece algo como:

```text
npm ERR! code EACCES
npm ERR! syscall mkdir
npm ERR! path /usr/local/lib/node_modules/<paquete>
npm ERR! errno -13
npm ERR! Error: EACCES: permission denied, mkdir '/usr/local/lib/node_modules/<paquete>'
npm ERR!  [Error: EACCES: permission denied, mkdir '/usr/local/lib/node_modules/<paquete>'] {
npm ERR!   errno: -13,
npm ERR!   code: 'EACCES',
npm ERR!   syscall: 'mkdir',
npm ERR!   path: '/usr/local/lib/node_modules/<paquete>'
npm ERR! }
npm ERR!
npm ERR! The operation was rejected by your operating system.
npm ERR! It is likely you do not have the permissions to access this file as the current user
```

## Causa

Por defecto, npm instala los paquetes globales en un directorio del sistema (`/usr/local/lib/node_modules` o `/usr/lib/node_modules`) que pertenece a `root`. Tu usuario normal no tiene permisos de escritura ahí, por eso `mkdir` falla con `EACCES` (permission denied).

```
Usuario:        arcanis
Directorio:     /usr/local/lib/node_modules   (dueño: root)
Permisos:       drwxr-xr-x   →  r-x para "otros"  →  no puede escribir
```

## ❌ Soluciones que NO debes usar

### 1. `sudo npm install -g ...`

Funciona, pero es **peligroso**:

- Ejecuta scripts post-install como `root`.
- Los binarios instalados son de `root` y luego pueden dar problemas de permisos al actualizar.
- npm recomienda explícitamente **no** usar sudo con npm.

```bash
# ❌ Evitar
sudo npm install -g nodemon
```

### 2. `chmod 777` sobre `/usr/lib/node_modules`

```bash
# ❌ Pésima idea: abre permisos a todo el mundo
sudo chmod -R 777 /usr/lib/node_modules
```

## ✅ Soluciones correctas (de peor a mejor)

### Solución A — Cambiar el `prefix` de npm a tu home

Esta es la **solución oficial recomendada por npm** cuando no usas un gestor de versiones.

```bash
# 1. Crear un directorio para paquetes globales
mkdir ~/.npm-global

# 2. Configurar npm para que lo use
npm config set prefix '~/.npm-global'

# 3. Añadir al PATH (bash o zsh)
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
# En zsh: echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc && source ~/.zshrc

# 4. Probar
npm install -g nodemon
nodemon --version
```

Para zsh, sustituye `.bashrc` por `.zshrc`.

#### Verificar la configuración

```bash
npm config get prefix
# /home/arcanis/.npm-global

npm config list
```

### Solución B — Usar nvm (RECOMENDADA)

`nvm` (Node Version Manager) instala Node.js dentro de tu home, sin `root`. Como todo es del usuario, los `npm install -g` no necesitan permisos especiales.

```bash
# 1. Instalar nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 2. Recargar shell (o abrir nueva terminal)
source ~/.bashrc

# 3. Instalar Node
nvm install --lts
nvm use --lts

# 4. Verificar
which node    # /home/arcanis/.nvm/versions/node/v20.x.x/bin/node
which npm     # /home/arcanis/.nvm/versions/node/v20.x.x/bin/npm

# 5. Ahora los globales funcionan sin sudo
npm install -g nodemon
```

Ventajas de nvm:

- Cada versión de Node tiene su propio `node_modules` global dentro de tu home.
- Cambiar de versión de Node en un comando.
- No hay `EACCES` nunca, porque nada pertenece a `root`.

### Solución C — `chown` del directorio de npm (si ya instalaste con sudo antes)

Si en el pasado usaste `sudo npm install -g` y ahora tienes archivos mezclados de `root` y de tu usuario:

```bash
# Ver quién es el dueño actual
ls -ld /usr/local/lib/node_modules
ls -l /usr/local/lib/node_modules

# Cambiar el dueño a tu usuario (solo si no usas nvm)
sudo chown -R $(whoami) /usr/local/lib/node_modules
sudo chown -R $(whoami) /usr/local/bin
sudo chown -R $(whoami) /usr/local/share
```

> ⚠️ Solo tiene sentido si Node se instaló a nivel de sistema (apt, etc.). Si usas nvm o ya cambiaste el `prefix`, **no** hagas esto.

### Solución D — `--no-save` (caso concreto, NO es para permisos)

La flag `--no-save` **no resuelve el problema de permisos**, pero aparece en discusiones relacionadas. Sirve para que npm **no** actualice `package.json` al instalar:

```bash
npm install lodash --no-save
# instala en node_modules locales pero NO modifica package.json
```

Casos de uso de `--no-save`:

- Probar un paquete rápido sin tocar tu `package.json`.
- Entornos de CI donde no quieres que un install accidental modifique el lockfile.

No lo confundas con una solución para `EACCES`: ese error es de **permisos del sistema de archivos**, no de `package.json`.

## Diagnosticar el origen del error

Comprueba dónde intenta escribir npm:

```bash
# Dónde instala globales
npm config get prefix
npm bin -g            # o: npm prefix -g

# Dónde está npm
which npm
ls -la $(which npm)
```

Salida típica con nvm:

```
/home/arcanis/.nvm/versions/node/v20.11.1
```

Salida típica con instalación de sistema (problemática):

```
/usr/local
```

## Tabla resumen de soluciones

| Método | ¿Recomendado? | Comentario |
|---|---|---|
| `sudo npm install -g` | ❌ | Peligroso, scripts como root |
| `chmod 777` directorios | ❌ | Inseguro |
| `npm config set prefix ~/.npm-global` | ✅ | Solución oficial sin nvm |
| **nvm** | ✅✅ | La mejor opción a largo plazo |
| `chown` del directorio de npm | ⚠️ | Solo si instalaste Node a nivel de sistema |
| `--no-save` | ➖ | No es para permisos, es para no tocar package.json |

## Limpieza tras cambiar a nvm

Si venías usando `sudo` y quieres migrar a nvm limpio:

```bash
# 1. Instalar nvm y una versión de Node (ver arriba)

# 2. Borrar los paquetes globales del viejo npm de sistema
sudo rm -rf /usr/local/lib/node_modules
sudo rm -f /usr/local/bin/<paquetes-globales>

# 3. Reinstalar tus globales con el nuevo npm
npm install -g nodemon eslint prettier typescript
```

## Comprobar que todo funciona

```bash
npm config get prefix       # apunta a tu home
npm install -g cowsay       # prueba sin sudo
cowsay "éxito"               # funciona
```

## Notas finales

- El error `EACCES` es de **permisos del SO**, no de npm en sí.
- La raíz casi siempre es: npm intenta escribir donde solo `root` puede.
- La solución definitiva es que todo Node/npm viva dentro de tu `HOME` (nvm lo hace automáticamente).
- Si usas `pnpm` o `yarn`, la idea es la misma: configura su store/global dentro de tu home.
- En macOS, `chown` de `/usr/local` es una alternativa antigua; hoy se prefiere `nvm` o Homebrew Node.
