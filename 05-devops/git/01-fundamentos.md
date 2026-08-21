# 01 — Fundamentos de Git

## Objetivos

- [ ] Entender qué es un sistema de control de versiones (VCS)
- [ ] Diferenciar Git de otros VCS (CVS, Subversion, Mercurial)
- [ ] Instalar y configurar Git (`user.name`, `user.email`, editor)
- [ ] Crear un repositorio con `git init` y `git clone`
- [ ] Conocer los tres estados: untracked, staged, committed
- [ ] Usar `git add` y `git commit`
- [ ] Consultar el historial con `git log`
- [ ] Comparar cambios con `git diff`
- [ ] Ignorar archivos con `.gitignore`
- [ ] Entender qué es `HEAD` y los tres estados del flujo de trabajo

## Apuntes

### ¿Qué es el control de versiones?

Un **sistema de control de versiones (VCS)** registra los cambios sobre un conjunto de archivos a lo largo del tiempo, de modo que puedas recuperar versiones concretas más adelante. Permite:

- Revertir archivos o proyectos enteros a un estado anterior.
- Comparar cambios a lo largo del tiempo.
- Detectar quién introdujo un cambio y cuándo (responsabilidad / `blame`).
- Trabajar en paralelo con otras personas sin sobrescribir el trabajo ajeno.

### Git vs otros VCS

| Característica | Git (DVCS) | Subversion/SVN (CVCS) | Mercurial (DVCS) | CVS (CVCS) |
|---|---|---|---|---|
| Modelo | Distribuido | Centralizado | Distribuido | Centralizado |
| Trabaja sin red | Sí (copia completa) | No | Sí | No |
| Ramas | Baratas (punteros) | Caras (copias) | Baratas | Prácticamente no hay |
| Velocidad local | Muy rápida | Depende del servidor | Rápida | Lenta |
| Fusión (merge) | Potente, modelada | Lineal | Buena | Débil |
| Almacenamiento | Snapshot de cada commit | Delta entre revisiones | Snapshot | Delta |

La diferencia clave: en un **CVCS centralizado** (SVN, CVS) el servidor guarda todo el historial y los clientes solo tienen la copia de trabajo; si el servidor cae y no hay backup, se pierde todo. En un **DVCS distribuido** (Git, Mercurial) cada clon es una copia completa del historial, así que cualquier clon puede restaurar el servidor.

### Instalación y configuración

Instalación:

```bash
# Debian/Ubuntu
sudo apt install git
# Fedora
sudo dnf install git
# macOS (Xcode Command Line Tools o Homebrew)
xcode-select --install || brew install git
# Windows
winget install Git.Git   # o descargar git-scm.com
```

Verificar:

```bash
git --version            # git version 2.45.x
```

Configuración mínima obligatoria antes del primer commit (si no la pones, Git falla o usa datos por defecto):

```bash
# Identidad del autor (queda registrada en cada commit)
git config --global user.name  "Ana Pérez"
git config --global user.email "ana@example.com"

# Editor por defecto para mensajes de commit y rebase interactivo
git config --global core.editor "code --wait"      # VS Code
git config --global core.editor "nvim"             # Neovim
git config --global core.editor "nano"             # Nano

# Nombre de la rama por defecto al crear un repo nuevo
git config --global init.defaultBranch main

# Colores en la salida
git config --global color.ui auto

# Inicial de ramas en checkout
git config --global checkout.defaultRemote origin
```

Ámbitos de configuración (`--global` es lo más común):

```bash
git config --system ...   # /etc/gitconfig (todos los usuarios)
git config --global ...    # ~/.gitconfig  (tu usuario)
git config --local  ...    # .git/config   (solo este repo)
```

Inspeccionar la configuración:

```bash
git config --list
git config --list --show-origin      # indica de qué archivo viene cada valor
git config user.name                 # leer un valor concreto
```

### Crear un repositorio: `init` y `clone`

```bash
# 1) Crear un repo nuevo desde un directorio vacío
mkdir mi-proyecto && cd mi-proyecto
git init                       # crea .git/ (la base de datos del repo)
# opcional: cambiar el nombre de la rama inicial
git branch -M main

# 2) Copiar un repo existente (clonar)
git clone https://github.com/usuario/repo.git
git clone git@github.com:usuario/repo.git        # por SSH
git clone https://github.com/usuario/repo.git mi-carpeta   # en otra carpeta
git clone --depth 1 <url>                       # clonado superficial (solo último commit)
```

Tras `git init`, aparece un directorio oculto `.git/` que contiene toda la base de datos del repositorio (objetos, refs, configuración, hooks). Borrar ese directorio destruye el historial.

### Estados de los archivos

Git maneja tres estados principales para los archivos de tu carpeta de trabajo:

```
Working Directory  ──git add──▶  Staging Area (index)  ──git commit──▶  Repository (.git)
 (modificado)                      (staged)                              (committed)
```

| Estado | Significado | Cómo verlo |
|---|---|---|
| **Untracked** | Git no lo sigue todavía | `git status` → "Untracked files" |
| **Modified** | Cambiado respecto al último commit | `git status` → "Changes not staged for commit" |
| **Staged** | Marcado para entrar en el próximo commit | `git status` → "Changes to be committed" |
| **Committed** | Guardado en el historial | `git log` |

### `add`, `commit` y `status`

```bash
git status                     # estado resumido
git status -s                  # formato corto (M=modified, A=added, ??=untracked)

# Añadir al staging
git add README.md              # un archivo
git add .                      # todo en el directorio actual (¡cuidado con lo que captura!)
git add -A                     # todos los cambios (incluidos borrados) en todo el repo
git add -p                     # interactivo: eliges qué "trozos" (hunks) añadir

# Crear un commit
git commit -m "feat: añade página de inicio"
git commit                     # abre el editor para escribir el mensaje
git commit -am "msg"           # add + commit SOLO de archivos ya seguidos (no untracked)
git commit --amend -m "msg"   # corrige el último commit (¡no usar en commits ya publicados!)
```

Buenas prácticas en el mensaje del commit:

- Primera línea ≤ 50 caracteres, en imperativo ("añade", no "añadido").
- Línea en blanco y luego descripción detallada (≤ 72 caracteres por línea).
- Referenciar issues: `Closes #42`.

### Historial: `git log`

```bash
git log                          # historial completo
git log --oneline                # una línea por commit
git log --oneline --graph        # con grafo de ramas
git log -n 5                     # últimos 5 commits
git log --stat                   # con archivos modificados
git log -p                       # con el diff de cada commit
git log --author="Ana"           # filtrar por autor
git log --since="2 weeks ago"    # filtrar por fecha
git log -- archivo.md            # historial de un archivo concreto
git log --grep="bug"             # buscar en mensajes de commit
```

### Comparar cambios: `git diff`

```bash
git diff                         # working dir vs staging (cambios sin añadir)
git diff --staged                # staging vs último commit (lo que se va a commitear)
git diff HEAD                    # working dir vs último commit (todo)
git diff a1b2c3d 4e5f6a7         # entre dos commits
git diff main feature            # entre dos ramas
git diff --stat                  # solo resumen de archivos modificados
git diff --archivo.md            # cambios en un archivo
```

### Ignorar archivos: `.gitignore`

Un archivo `.gitignore` en la raíz del repo indica a Git qué rutas ignorar. Se versiona con el resto del repo.

```gitignore
# Comentarios con #

# Por extensión
*.log
*.tmp
*.swp

# Directorios completos
node_modules/
dist/
build/
coverage/

# Archivos concretos
.env
.env.local

# Excepciones (¡ojo: no se puede re-ignorar un directorio ya ignorado por un patrón padre!)
!dist/important.txt

# Por sistema operativo
.DS_Store       # macOS
Thumbs.db       # Windows
```

Reglas importantes:

- `.gitignore` **no borra** archivos que ya están commiteados; primero hay que `git rm --cached`.
- Los patrones son relativos a la carpeta del `.gitignore`.
- Un patrón que empieza con `/` se ancla a la raíz: `/build` ignora solo `build/` en la raíz, no `paquete/build/`.
- Un patrón que termina en `/` solo coincide con directorios.

```bash
# Dejar de seguir un archivo ya commiteado (sin borrarlo del disco)
git rm --cached .env
echo ".env" >> .gitignore
git commit -m "chore: deja de versionar .env"
```

### HEAD y el flujo de los tres estados

`HEAD` es un puntero especial a la referencia donde te encuentras (normalmente la rama actual). Un commit es un snapshot del árbol completo más metadatos (autor, fecha, mensaje y puntero(s) al commit padre).

```
HEAD ──▶ main ──▶ commit C ──▶ commit B ──▶ commit A (inicial)
```

- `HEAD` apunta a `main`; `main` apunta a `C`; el padre de `C` es `B`, etc.
- `HEAD~1` = padre de `HEAD`, `HEAD~2` = abuelo, `HEAD^^` equivalente.
- `HEAD@{1}` en el reflog = la posición anterior de `HEAD`.

Referencias relativas útiles:

| Expresión | Significado |
|---|---|
| `HEAD` | Commit actual |
| `HEAD~1` / `HEAD^` | Primer padre |
| `HEAD~3` | Tres padres atrás |
| `HEAD@{2}` | Posición de HEAD hace 2 movimientos (reflog) |
| `rama^` | Padre de la rama |
| `rama~2` | Dos commits atrás desde la rama |

### Flujo de trabajo básico (resumen)

```bash
git init                                # 1) crear repo
echo "# Mi proyecto" > README.md
git add README.md                       # 2) pasar a staging
git commit -m "chore: commit inicial"  # 3) guardar en el historial
git log --oneline                       # 4) revisar el historial
# editar archivo...
git diff                                # 5) ver qué cambié
git add README.md && git commit -m "docs: mejora README"
```

## Conceptos clave

| Concepto | Definición breve |
|---|---|
| **Repositorio (repo)** | Carpeta con un `.git/` que guarda todo el historial |
| **Commit** | Snapshot del árbol + metadatos (autor, fecha, mensaje, padre) |
| **Working directory** | Los archivos tal cual los ves en disco |
| **Staging area / index** | Zona intermedia donde preparas el próximo commit |
| **HEAD** | Puntero al commit/rama actual |
| **Rama** | Puntero móvil a un commit; crear ramas es casi gratis |
| **`.git/`** | Base de datos del repo; borrarla destruye el historial |
| **Hash SHA-1** | Identificador de 40 hex de cada objeto (commit, árbol, blob) |

## Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `*** Please tell me who you are` | No configuraste `user.name`/`user.email` | `git config --global user.name "..."` y `user.email` |
| `nothing to commit, working tree clean` | Olvidaste `git add` antes de commit | `git add <archivo>` y luego `git commit` |
| Archivo en `.gitignore` sigue apareciendo | Ya estaba commiteado antes de ignorarlo | `git rm --cached <archivo>` y commitear |
| `fatal: not a git repository` | No estás dentro de un repo | `cd` a la carpeta correcta o `git init` |
| Commit con usuario/email equivocado | `git config` mal puesto o ámbito local pisa el global | `git config user.email` (local) y `git commit --amend --reset-author` |
| `git add .` sube archivos sensibles | Captura todo, incluido `.env` | Usar `.gitignore` y `git add -p` para revisar hunks |
| `error: pathspec 'X' did not match` | Nombre de archivo mal escrito o no existe | Verificar con `git status` |
| `detached HEAD` | Hiciste `checkout` a un commit en vez de a una rama | Crear rama: `git switch -c nueva-rama` |
