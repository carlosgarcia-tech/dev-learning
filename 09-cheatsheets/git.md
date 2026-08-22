# Chuleta de Git

Referencia rápida y completa de Git organizada por categorías. Pensada para tener a mano los comandos más usados y los avanzados.

## Índice

- [Configuración](#configuración)
- [Repositorio local](#repositorio-local)
- [Staging area](#staging-area)
- [Commits](#commits)
- [Ramas](#ramas)
- [Fusión (merge)](#fusión-merge)
- [Remotos](#remotos)
- [Inspección](#inspección)
- [Stash](#stash)
- [Rebase](#rebase)
- [Cherry-pick](#cherry-pick)
- [Reflog](#reflog)
- [Bisect](#bisect)
- [Submodules](#submodules)
- [Tags](#tags)
- [LFS (Large File Storage)](#lfs-large-file-storage)
- [Config avanzada](#config-avanzada)

---

## Configuración

| Comando | Descripción |
|---|---|
| `git config --global user.name "Nombre"` | Nombre del autor de los commits |
| `git config --global user.email "email@dominio.com"` | Email del autor |
| `git config --global init.defaultBranch main` | Rama por defecto al crear repos |
| `git config --global core.editor "code --wait"` | Editor por defecto |
| `git config --global pull.rebase false` | Merge en lugar de rebase al hacer pull |
| `git config --global core.autocrlf input` | Normalizar finales de línea (Linux/macOS) |
| `git config --global alias.s "status -sb"` | Crear alias `git s` |
| `git config --list` | Ver toda la configuración |
| `git config --global --edit` | Editar `.gitconfig` directamente |

```bash
# Configuración inicial recomendada
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor "code --wait"
git config --global alias.lg "log --oneline --graph --decorate --all"
```

---

## Repositorio local

| Comando | Descripción |
|---|---|
| `git init` | Inicializa un repo en el directorio actual |
| `git init --bare` | Crea un repo sin working tree (para servidores) |
| `git clone <url>` | Clona un repo remoto |
| `git clone <url> <dir>` | Clona en un directorio específico |
| `git clone --depth 1 <url>` | Clon superficial (solo último commit) |
| `git clone --recurse-submodules <url>` | Clona incluyendo submódulos |
| `git status` | Estado del working tree y staging |
| `git status -sb` | Estado corto con rama |

```bash
git init
git remote add origin git@github.com:usuario/repo.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

---

## Staging area

| Comando | Descripción |
|---|---|
| `git add <archivo>` | Añade un archivo al staging |
| `git add .` | Añade todos los cambios (directorio actual) |
| `git add -A` | Añade todos los cambios (todo el repo) |
| `git add -p` | Añade por trozos (interactivo) |
| `git add -u` | Añade solo modificaciones/eliminaciones (no nuevas) |
| `git rm <archivo>` | Elimina y hace stage de la eliminación |
| `git rm --cached <archivo>` | Deja de trackear sin borrar el archivo |
| `git mv <origen> <destino>` | Mueve/renombra y hace stage |
| `git restore <archivo>` | Descarta cambios sin commitear |
| `git restore --staged <archivo>` | Quita del staging (después de `add`) |
| `git restore --source=HEAD~1 <archivo>` | Restaura desde un commit concreto |

```bash
# Añadir por trozos: útil para commits atómicos
git add -p

# Quitar del staging algo que ya añadiste por error
git restore --staged archivo.txt
```

---

## Commits

| Comando | Descripción |
|---|---|
| `git commit -m "mensaje"` | Commit con mensaje |
| `git commit -am "mensaje"` | Add + commit (solo modificados trackeados) |
| `git commit --amend` | Modifica el último commit |
| `git commit --amend --no-edit` | Amend sin cambiar el mensaje |
| `git commit --amend --author="Nombre <email>"` | Cambiar el autor |
| `git commit --date="2025-01-01T12:00:00"` | Cambiar la fecha del commit |
| `git commit -S -m "mensaje"` | Firmar con GPG |
| `git commit --allow-empty` | Commit sin cambios |

```bash
# Buenas prácticas de mensajes (Conventional Commits)
git commit -m "feat: añade login con JWT"
git commit -m "fix: corrige validación de email"
git commit -m "docs: actualiza README"
git commit -m "refactor: extrae servicio de auth"
git commit -m "test: añade tests de usuario"
git commit -m "chore: actualiza dependencias"
```

---

## Ramas

| Comando | Descripción |
|---|---|
| `git branch` | Lista ramas locales |
| `git branch -a` | Lista todas (locales y remotas) |
| `git branch -vv` | Lista con tracking y último commit |
| `git branch <nombre>` | Crea una rama |
| `git branch -d <nombre>` | Borra rama (si está fusionada) |
| `git branch -D <nombre>` | Borra rama a la fuerza |
| `git branch -m <nuevo>` | Renombra la rama actual |
| `git branch -m <viejo> <nuevo>` | Renombra una rama |
| `git switch <rama>` | Cambia de rama (moderno) |
| `git switch -c <rama>` | Crea y cambia de rama |
| `git switch -` | Vuelve a la rama anterior |
| `git checkout <rama>` | Cambia de rama (clásico) |
| `git checkout -b <rama>` | Crea y cambia (clásico) |

```bash
# Flujo típico de feature
git switch -c feature/login
# ... trabajar ...
git add -A
git commit -m "feat: implementa login"
git push -u origin feature/login
```

---

## Fusión (merge)

| Comando | Descripción |
|---|---|
| `git merge <rama>` | Fusiona `<rama>` en la actual |
| `git merge --no-ff <rama>` | Fuerza commit de merge |
| `git merge --ff-only <rama>` | Solo fast-forward (si es posible) |
| `git merge --squash <rama>` | Junta todos los commits en uno |
| `git merge --abort` | Cancela un merge en conflicto |
| `git merge -X theirs <rama>` | Resuelve conflictos a favor de la rama entrante |
| `git merge -X ours <rama>` | Resuelve a favor de la rama actual |

```bash
# Resolver conflictos
git merge feature/x
# Si hay conflictos: editar archivos, marcar como resueltos
git add archivo_resuelto.txt
git commit
# Abortar si te equivocas
git merge --abort
```

---

## Remotos

| Comando | Descripción |
|---|---|
| `git remote -v` | Lista remotos con URLs |
| `git remote add origin <url>` | Añade un remoto |
| `git remote set-url origin <url>` | Cambia la URL de un remoto |
| `git remote rename <a> <b>` | Renombra un remoto |
| `git remote remove origin` | Elimina un remoto |
| `git fetch origin` | Descarga cambios sin fusionar |
| `git fetch --all --prune` | Todos los remotos, borra ramas muertas |
| `git pull` | Fetch + merge de la rama actual |
| `git pull --rebase` | Fetch + rebase |
| `git push` | Sube commits |
| `git push -u origin <rama>` | Sube y configura tracking |
| `git push --force-with-lease` | Force push seguro (no sobrescribe cambios ajenos) |
| `git push --tags` | Sube los tags |
| `git push origin --delete <rama>` | Borra rama remota |

```bash
# Cambiar de HTTPS a SSH
git remote set-url origin git@github.com:usuario/repo.git

# Force push seguro (preferible a --force)
git push --force-with-lease
```

---

## Inspección

| Comando | Descripción |
|---|---|
| `git log` | Historial completo |
| `git log --oneline` | Una línea por commit |
| `git log --graph --oneline --all` | Árbol de todas las ramas |
| `git log -p <archivo>` | Historial con diffs de un archivo |
| `git log --stat` | Estadísticas de archivos cambiados |
| `git log --author="nombre"` | Filtra por autor |
| `git log --since="2 weeks ago"` | Filtra por fecha |
| `git log -S "función"` | Busca cambios que añaden/quitan una cadena |
| `git log -G "regex"` | Busca cambios con regex en el diff |
| `git show <commit>` | Muestra un commit concreto |
| `git show HEAD~1` | El commit anterior |
| `git diff` | Cambios sin commitear (working vs staging) |
| `git diff --staged` | Cambios en staging (vs HEAD) |
| `git diff HEAD` | Todos los cambios (vs último commit) |
| `git diff <a>..<b>` | Diferencia entre dos commits |
| `git diff --stat` | Resumen de cambios |
| `git blame <archivo>` | Autor por línea |
| `git blame -L 10,20 <archivo>` | Líneas 10-20 |
| `git shortlog -sn` | Nº de commits por autor |

```bash
# Mi alias favorito de log
git log --oneline --graph --decorate --all
# Versión compacta
git log --oneline -10
```

---

## Stash

| Comando | Descripción |
|---|---|
| `git stash` | Guarda cambios temporalmente |
| `git stash push -m "descripcion"` | Stash con mensaje |
| `git stash -u` | Incluye archivos nuevos (untracked) |
| `git stash -a` | Incluye también los ignorados |
| `git stash list` | Lista los stashes |
| `git stash show -p stash@{0}` | Muestra el contenido |
| `git stash pop` | Aplica y borra el último stash |
| `git stash apply` | Aplica sin borrar |
| `git stash apply stash@{2}` | Aplica un stash concreto |
| `git stash drop stash@{0}` | Borra un stash |
| `git stash clear` | Borra todos los stashes |

```bash
# Cambiar de rama con trabajo a medias
git stash push -m "wip: login a medias"
git switch main
git pull
git switch -
git stash pop
```

---

## Rebase

| Comando | Descripción |
|---|---|
| `git rebase <rama>` | Reaplaca commits sobre `<rama>` |
| `git rebase -i HEAD~3` | Rebase interactivo de los últimos 3 commits |
| `git rebase --onto <base> <desde> <hasta>` | Rebase avanzado |
| `git rebase --abort` | Cancela un rebase |
| `git rebase --continue` | Continuar tras resolver conflicto |
| `git rebase --skip` | Salta el commit actual en conflicto |
| `git rebase -i --autosquash` | Reordena fixup! automáticamente |

Acciones en rebase interactivo:

| Palabra | Acción |
|---|---|
| `pick` | Conservar el commit |
| `reword` | Cambiar el mensaje |
| `edit` | Pausar para modificar el commit |
| `squash` | Fusionar con el anterior |
| `fixup` | Fusionar descartando el mensaje |
| `drop` | Eliminar el commit |
| `exec` | Ejecutar un comando |

```bash
# Alinear feature con main antes de PR
git switch feature
git fetch origin
git rebase origin/main
# Resolver conflictos si los hay
git add .
git rebase --continue
git push --force-with-lease

# Comprimir los últimos 4 commits en uno
git rebase -i HEAD~4
```

---

## Cherry-pick

| Comando | Descripción |
|---|---|
| `git cherry-pick <commit>` | Aplica un commit en la rama actual |
| `git cherry-pick <c1> <c2>` | Varios commits |
| `git cherry-pick <a>..<b>` | Rango de commits |
| `git cherry-pick --no-commit <commit>` | Aplica cambios sin commitear |
| `git cherry-pick --continue` | Tras resolver conflicto |
| `git cherry-pick --abort` | Cancela el cherry-pick |

```bash
# Traer un hotfix de main a una rama de release
git switch release
git cherry-pick a1b2c3d
```

---

## Reflog

| Comando | Descripción |
|---|---|
| `git reflog` | Historial de movimientos de HEAD |
| `git reflog --relative-date` | Con fechas relativas |
| `git reset --hard HEAD@{2}` | Vuelve al estado de reflog {2} |
| `git reset --hard <commit>` | A un commit concreto |

```bash
# Recuperar commits "perdidos" tras un reset o rebase
git reflog
# a1b2c3d HEAD@{0}: reset: moving to HEAD~1
# f4e5d6c HEAD@{1}: commit: trabajo importante
git reset --hard f4e5d6c
```

> El reflog es local y dura ~90 días por defecto. Es la red de seguridad para recuperar trabajo "borrado".

---

## Bisect

| Comando | Descripción |
|---|---|
| `git bisect start` | Inicia la búsqueda binaria |
| `git bisect bad` | Marca el commit actual como roto |
| `git bisect good <commit>` | Marca un commit conocido como bueno |
| `git bisect good/bad` | Clasifica cada commit que Git comprueba |
| `git bisect reset` | Termina y vuelve a la rama |
| `git bisect run <script>` | Automatiza con un script |

```bash
# Búsqueda binaria de un bug
git bisect start
git bisect bad                 # commit actual roto
git bisect good v1.0.0         # tag conocido que funcionaba
# Git irá moviéndote por commits; responde good/bad hasta encontrar el culpable
git bisect reset
```

---

## Submodules

| Comando | Descripción |
|---|---|
| `git submodule add <url> <dir>` | Añade un submódulo |
| `git submodule init` | Inicializa submódulos |
| `git submodule update` | Descarga el commit registrado |
| `git submodule update --init --recursive` | Todo anidado |
| `git submodule update --remote` | Actualiza a último commit de la rama |
| `git submodule deinit -f <dir>` | Desactiva un submódulo |
| `git rm <dir>` | Elimina un submódulo |

```bash
# Clonar un repo con submódulos
git clone --recurse-submodules <url>

# Si ya clonaste sin --recurse
git submodule update --init --recursive
```

---

## Tags

| Comando | Descripción |
|---|---|
| `git tag` | Lista los tags |
| `git tag v1.0.0` | Tag ligero |
| `git tag -a v1.0.0 -m "Release 1.0"` | Tag anotado (recomendado) |
| `git tag <tag> <commit>` | Tag en un commit concreto |
| `git tag -d v1.0.0` | Borra un tag local |
| `git push origin v1.0.0` | Sube un tag |
| `git push origin --tags` | Sube todos los tags |
| `git push origin --delete v1.0.0` | Borra tag remoto |
| `git describe --tags` | Último tag relativo |

```bash
git tag -a v1.2.0 -m "Release 1.2.0"
git push origin v1.2.0
```

---

## LFS (Large File Storage)

| Comando | Descripción |
|---|---|
| `git lfs install` | Activa LFS en el repo |
| `git lfs track "*.psd"` | Trackea un tipo de archivo |
| `git lfs track` | Lista reglas de tracking |
| `git lfs ls-files` | Archivos gestionados por LFS |
| `git lfs pull` | Descarga contenido LFS |
| `git lfs push origin main` | Sube contenido LFS |
| `git lfs migrate import --include="*.zip"` | Migra histórico a LFS |

```bash
git lfs install
git lfs track "*.mp4" "*.zip" "*.psd"
git add .gitattributes
git commit -m "chore: configura LFS"
git add video.mp4
git commit -m "feat: añade vídeo"
git push
```

---

## Config avanzada

| Comando | Descripción |
|---|---|
| `git config --global rebase.autoSquash true` | Activa autosquash |
| `git config --global help.autocorrect 10` | Autocorrige comandos (1s) |
| `git config --global diff.tool vimdiff` | Herramienta de diff |
| `git config --global merge.tool vimdiff` | Herramienta de merge |
| `git config --global rerere.enabled true` | Reutiliza resoluciones de conflictos |
| `git config --global commit.template ~/.gitmessage` | Plantilla de mensaje |
| `git config --global commit.gpgsign true` | Firma todos los commits |
| `git config --global color.ui auto` | Colores |
| `git config --global blame.markIgnoredLines true` | Muestra líneas ignoradas |
| `git config core.hooksPath .githooks` | Carpeta personal de hooks |

### Hooks más útiles

| Hook | Cuándo | Uso típico |
|---|---|---|
| `pre-commit` | Antes de commit | Linter, formateo, tests rápidos |
| `commit-msg` | Al escribir mensaje | Validar formato (Conventional Commits) |
| `pre-push` | Antes de push | Tests completos |
| `post-merge` | Tras merge | Instalar dependencias |

```bash
# Ignorar globalmente
git config --global core.excludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global
echo "node_modules/" >> ~/.gitignore_global
```

### Resolver "detached HEAD"

```bash
# Estás en un commit suelto; crea una rama para no perderlo
git switch -c rescue-branch
```

### Deshacer cambios según estado

| Situación | Comando |
|---|---|
| Cambios sin add | `git restore <archivo>` |
| Cambios en staging | `git restore --staged <archivo>` y luego `git restore <archivo>` |
| Commit no pusheado | `git reset --soft HEAD~1` (conserva cambios en staging) |
| Commit no pusheado (descartar) | `git reset --hard HEAD~1` |
| Commit ya pusheado | `git revert <commit>` (crea commit inverso) |

### .gitignore por capas

```gitignore
# Global: ~/.gitignore_global
.DS_Store
node_modules/
*.log

# Local: .gitignore del repo
/build/
.env
*.local

# Excepciones (negación)
!important.log
```
