# 02 — Ramas y remotos

## Objetivos

- [ ] Entender qué es una rama y por qué son baratas en Git
- [ ] Crear, listar, cambiar y borrar ramas con `branch`/`checkout`/`switch`
- [ ] Fusionar ramas con `merge` y distinguir fast-forward vs merge commit
- [ ] Resolver conflictos de fusión
- [ ] Gestionar repositorios remotos con `remote`, `fetch`, `pull`, `push`
- [ ] Configurar tracking branches y upstream
- [ ] Clonar con `--depth` (shallow clone)
- [ ] Diferenciar `fork` de `clone`

## Apuntes

### Qué es una rama

Una rama en Git es **un puntero móvil a un commit**. Crear una rama no copia archivos: solo crea un nuevo puntero de 40 bytes. Por eso las ramas en Git son baratas y rápidas, a diferencia de SVN donde una rama es una copia completa del árbol.

```
             ┌── feature (rama)
             │
A ──▶ B ──▶ C ──▶ D ──▶ E
                       │
                       └── main (rama)  ← HEAD apunta aquí
```

### Crear, listar y borrar ramas

```bash
git branch                            # listar ramas locales
git branch -a                         # incluir ramas remotas
git branch -v                         # con último commit de cada rama
git branch feature/login              # crear rama (sin moverse)
git branch -m main                    # renombrar la rama actual a main
git branch -m vieja nueva             # renombrar otra rama
git branch -d feature/login           # borrar rama local (si está merged)
git branch -D feature/login           # borrar rama local A LA FUERZA (aunque no esté merged)
git push origin --delete feature/login  # borrar rama remota
```

### Cambiar de rama: `checkout` y `switch`

`git switch` (introducido en Git 2.23) es la forma moderna y más clara; `checkout` sigue funcionando pero hace muchas cosas (ramas, archivos, commits) y puede confundir.

```bash
# Cambiar a una rama existente
git checkout feature/login      # forma clásica
git switch feature/login         # forma moderna (recomendada)

# Crear y cambiar en un solo paso
git checkout -b feature/login    # clásica
git switch -c feature/login      # moderna

# Volver a la rama anterior
git switch -
git checkout -

# Crear rama desde otra rama o commit
git switch -c hotfix main
git switch -c experimento a1b2c3d
```

> ⚠️ Si tienes cambios sin commitear que entran en conflicto con la rama destino, Git te bloqueará el cambio. Haz `git stash`, commitea o usa `git switch -m` para mover los cambios.

### Fusionar ramas: `merge`

Para fusionar `feature` dentro de `main`:

```bash
git switch main
git merge feature/login
```

Git puede fusionar de dos formas:

#### 1) Fast-forward (avance rápido)

Ocurre cuando la rama destino (`main`) no ha avanzado desde que se creó la rama `feature`. Git simplemente mueve el puntero `main` hacia adelante, **sin crear commit de merge**.

```
Antes:   A ──▶ B (main)
              ╲
               ╲─▶ C ──▶ D (feature)

FF:      A ──▶ B ──▶ C ──▶ D (main, feature)
```

```bash
git merge feature          # fast-forward si es posible
git merge --no-ff feature  # forzar commit de merge (preserva historia de la rama)
```

#### 2) Merge commit (fusión de tres vías)

Cuando ambas ramas han avanzado, Git crea un **commit de merge** con dos padres. Es la fusión de tres vías (three-way merge).

```
          C ──▶ D (feature)
         /         ╲
A ──▶ B              ╲─▶ M (merge commit, main)
         ╲         /
          E ──▶ F (main)
```

#### Cuándo elegir `--no-ff`

- En flujos con ramas de feature: `--no-ff` preserva que existió una rama y agrupa sus commits.
- En trunk-based: `--ff` (rebase primero) mantiene la historia lineal.

### Conflictos de fusión

Un conflicto ocurre cuando ambas ramas modifican **las mismas líneas** de un mismo archivo. Git no decide por ti; marca el conflicto:

```
<<<<<<< HEAD
versión de la rama actual (main)
=======
versión de la rama entrante (feature)
>>>>>>> feature/login
```

Resolución manual:

```bash
git merge feature/login
# CONFLICTO: edita el archivo y elige la versión correcta (o combínalas)
git add archivo-conflictivo.md      # marcar como resuelto
git commit                          # completar el merge commit
```

Herramientas:

```bash
git mergetool                       # abrir herramienta visual (kdiff3, meld, VS Code)
git diff --name-only --diff-filter=U  # listar archivos en conflicto
git merge --abort                   # cancelar el merge y volver al estado anterior
```

Estrategias para conflictos grandes:

- Rebasar la rama feature contra `main` antes de fusionar (`git rebase main`), resolviendo conflicto a conflicto.
- Hacer merges pequeños y frecuentes (menos superficie de conflicto).
- Usar `git checkout --ours` / `git checkout --theirs` para aceptar toda una versión de un archivo.

```bash
git checkout --ours  archivo.md     # mantener la versión de la rama actual
git checkout --theirs archivo.md    # aceptar la versión de la rama entrante
```

### Repositorios remotos

Un **remoto** es otra copia del repo (en GitHub, GitLab, un servidor propio o la máquina de un compañero). Un repo puede tener varios remotos.

```bash
git remote -v                          # listar remotos con URL
git remote add origin https://github.com/usuario/repo.git
git remote add upstream https://github.com/proyecto-original/repo.git
git remote rename origin origen
git remote remove upstream
git remote show origin                 # detalles del remoto
git remote set-url origin git@github.com:usuario/repo.git   # cambiar URL
```

### `fetch`, `pull` y `push`

```bash
# Descargar cambios del remoto SIN fusionarlos
git fetch
git fetch origin
git fetch --all              # todos los remotos
git fetch --prune           # borrar referencias remotas que ya no existen

# Descargar Y fusionar la rama remota en la rama actual
git pull                    # = git fetch + git merge
git pull --rebase           # = git fetch + git rebase (historia lineal)

# Subir commits locales al remoto
git push origin main
git push                    # si hay upstream configurado
git push -u origin feature  # crear rama remota y configurar upstream
```

> ⚠️ `git pull` hace `fetch` + `merge` por defecto. Para historia lineal, configura rebase: `git config --global pull.rebase true`.

### Forzar y no forzar el push

Forzar sobrescribe la rama remota: es **peligroso** si otros ya descargaron esos commits.

```bash
git push --force             # NUNCA usar: sobrescribe sin miramientos
git push --force-with-lease  # PREFERIDO: solo fuerza si nadie más subió commits
git push -f                  # alias de --force
```

Regla: **nunca** forces push sobre ramas compartidas (`main`, `develop`). Solo fuerza sobre **tus** ramas de feature tras un rebase.

### Tracking branches y upstream

Una **tracking branch** es una rama local que sigue a una rama remota. Así `git pull`/`push` funcionan sin argumentos.

```bash
# Al clonar, se crea automáticamente main → origin/main (tracking)
git clone <url>

# Configurar upstream al subir por primera vez
git push -u origin feature      # -u = --set-upstream

# Configurar upstream a una rama existente
git branch -u origin/main main
git branch --set-upstream-to=origin/main main

# Ver tracking
git branch -vv
```

### Clonar con `--depth` (shallow clone)

Un clon shallow descarga solo los últimos N commits: útil para CI (rapidez) pero limitado (no tienes todo el historial).

```bash
git clone --depth 1 <url>               # solo el último commit
git clone --depth 5 <url>               # últimos 5 commits
git clone --shallow-since="2024-01-01" <url>  # commits desde una fecha
git fetch --unshallow                    # recuperar todo el historial después
```

### `fork` vs `clone`

| | `clone` | `fork` |
|---|---|---|
| Qué hace | Copia el repo a tu máquina | Copia el repo a tu cuenta de GitHub/GitLab |
| Dónde | Local | Servidor (GitHub/GitLab) |
| Permisos | Necesitas acceso de lectura (público basta) | No necesitas permisos sobre el original |
| Uso típico | Trabajar en un proyecto propio | Contribuir a un proyecto ajeno vía Pull Request |

Flujo típico de contribución con fork:

```bash
# 1) Fork en GitHub (botón Fork)
git clone https://github.com/TU-USUARIO/repo.git
git remote add upstream https://github.com/proyecto-original/repo.git
# 2) Trabajar en una rama feature
git switch -c fix/typo
# ... cambios ...
git push -u origin fix/typo
# 3) Abrir Pull Request en GitHub: origin/fix/typo → upstream/main
# 4) Mantener sincronizado con upstream
git fetch upstream
git rebase upstream/main
git push --force-with-lease
```

## Conceptos clave

| Concepto | Definición |
|---|---|
| **Rama** | Puntero móvil a un commit; casi gratis de crear |
| **HEAD** | Rama o commit en el que estás ahora |
| **Fast-forward** | Merge que solo avanza el puntero, sin commit de merge |
| **Merge commit** | Commit con dos padres que une dos historias |
| **Conflicto** | Cuando dos ramas cambian las mismas líneas; Git no decide |
| **Remoto** | Otra copia del repo (origin, upstream) |
| **Tracking branch** | Rama local ligada a una remota; permite `pull`/`push` sin args |
| **Upstream** | La rama remota que sigue una rama local |
| **Shallow clone** | Clon con historial limitado (`--depth`) |
| **Fork** | Copia del repo en tu cuenta del servidor |

## Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `error: Your local changes would be overwritten` | Tienes cambios sin commitear al cambiar de rama | `git stash`, commitear o `git switch -m` |
| `CONFLICT (content): Merge conflict` | Mismas líneas cambiadas en dos ramas | Resolver manualmente, `git add` y `git commit` |
| `! [rejected] main -> main (fetch first)` | El remoto tiene commits que no tienes | `git pull` antes de `git push` |
| `! [rejected] (non-fast-forward)` tras rebase | Reescribiste commits ya publicados | `git push --force-with-lease` (solo en tu rama) |
| `fatal: The current branch has no upstream` | Faltó `-u` al primer push | `git push -u origin <rama>` |
| `Your branch is ahead of 'origin/main' by N commits` | Tienes commits locales sin subir | `git push` |
| `Your branch is behind` | El remoto avanzó | `git pull` (o `fetch` + `merge`/`rebase`) |
| Merge accidental sobre la rama equivocada | Hiciste merge sin verificar la rama actual | `git merge --abort` antes de commitear |
