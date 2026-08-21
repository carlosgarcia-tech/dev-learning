# 04 — Avanzado

## Objetivos

- [ ] Dominar `git reset` en sus tres modos: soft, mixed y hard
- [ ] Diferenciar `revert` (crea commit) de `reset` (reescribe historial)
- [ ] Recuperar commits "perdidos" con `reflog`
- [ ] Consultar el historial con `git log` avanzado y formato personalizado
- [ ] Usar `bisect` para encontrar el commit que introdujo un bug
- [ ] Gestionar dependencias con `submodules`
- [ ] Hacer checkout parcial con `sparse-checkout`
- [ ] Trabajar en paralelo con `worktrees`
- [ ] Configurar y usar hooks de `pre-commit` y `pre-push`
- [ ] Manejar archivos grandes con Git LFS
- [ ] Aplicar filtros clean/smudge y `.gitattributes`
- [ ] Interpretar `git blame` / `git annotate`

## Apuntes

### `git reset`: soft, mixed, hard

`reset` mueve la rama actual (`HEAD`) a otro commit y, según el modo, afecta al staging y al working dir.

| Modo | Mueve HEAD | Staging (index) | Working dir | Caso de uso |
|---|---|---|---|---|
| `--soft` | Sí | No se toca | No se toca | Deshacer el último commit pero mantener cambios listos para commitear |
| `--mixed` (default) | Sí | Se resetea al commit destino | No se toca | Deshacer commit y dejar cambios sin staged |
| `--hard` | Sí | Se resetea | Se resetea (¡borra cambios!) | Descartar TODO y volver al commit destino |

```bash
git reset --soft HEAD~1        # deshace el último commit; cambios siguen staged
git reset HEAD~1               # = --mixed: cambios quedan unstaged
git reset --hard HEAD~1        # descarta el commit y los cambios del working dir
git reset --hard origin/main   # alinear local con el remoto (destruye cambios locales)
git reset a1b2c3d              # mover HEAD a ese commit (mixed)
git reset --hard ORIG_HEAD     # deshacer el último reset
```

Visualización del alcance de cada modo:

```
                  HEAD      Index      Working dir
--soft HEAD~1     mueve     intacto    intacto
--mixed HEAD~1    mueve     reset      intacto
--hard HEAD~1     mueve     reset      reset (¡cuidado!)
```

### `revert` vs `reset`

| | `git revert <commit>` | `git reset <commit>` |
|---|---|---|
| Qué hace | Crea un NUEVO commit que invierte los cambios | Mueve la rama hacia atrás (reescribe) |
| Historial | Conserva el commit original (historia intacta) | Reescribe la historia |
| Seguro en ramas públicas | Sí | No |
| Útil para | Deshacer commits ya publicados | Deshacer commits locales no publicados |

```bash
# revert: invierte de forma segura (crea commit)
git revert a1b2c3d
git revert HEAD~2              # revertir un commit antiguo
git revert a1b2c3d --no-commit # aplicar al staging sin commitear (múltiples reverts juntos)
git revert --continue          # tras resolver conflicto

# reset: reescribir historia (solo commits no publicados)
git reset --hard HEAD~3        # borra los últimos 3 commits
```

### Reflog y recuperación

El reflog guarda el historial local de movimientos de HEAD, incluso después de `reset --hard` o rebase. Mientras el commit no haya sido recogido por `git gc`, se puede recuperar.

```bash
git reflog                     # historial de HEAD
git reflog --all               # de todas las refs
git reflog show feature        # de una rama

# Ejemplo de recuperación
git reset --hard HEAD~5        # ups, me pasé
git reflog                     # busco el hash anterior
git reset --hard HEAD@{1}      # vuelvo al estado previo
git reset --hard a1b2c3d       # o por hash directo
```

Expiración por defecto: 90 días para refs inalcanzables, 30 días si son inalcanzables. El reflog es **local y por clon** (no se comparte).

### `git log` avanzado y formato

```bash
# Formato personalizado con --format
git log --format="%h %an %ar %s"          # hash corto, autor, fecha relativa, asunto
git log --format="%H %ai %s"               # hash largo, fecha ISO, asunto
git log --format="%an <%ae>" | sort -u     # lista de autores únicos

# Decoración del grafo
git log --oneline --graph --decorate --all

# Filtrado
git log --author="Ana" --grep="fix"        # por autor Y texto
git log --since="2024-01-01" --until="2024-06-30"
git log -S "funcionBorrada"                # commits que cambiaron el nº de ocurrencias
git log -G "regex"                         # commits que cambiaron líneas que matchean regex
git log --all --source --remotes           # incluir todas las refs

# Recorrido
git log main..feature                      # commits en feature NO en main
git log feature..main                      # commits en main NO en feature
git log main...feature                     # commits en uno u otro (diferencia simétrica)
git log --left-right main...feature        # indica de qué lado está cada uno

# Reflog y fechas
git log -g                                 # como reflog
git log --date=short                       # 2024-06-30
git log --date=format:"%Y-%m-%d %H:%M"

# Estadísticas
git log --shortstat                        # insertions/deletions
git log --numstat                          # archivos + líneas añadidas/borradas
git log --since="2 weeks ago" --oneline
```

Formatos útiles de `--format`:

| Marcador | Significado |
|---|---|
| `%H` / `%h` | Hash completo / corto |
| `%an` / `%ae` | Nombre / email del autor |
| `%cn` / `%ce` | Nombre / email del committer |
| `%ad` / `%ar` | Fecha autor / fecha relativa |
| `%s` | Asunto (primera línea del mensaje) |
| `%b` | Cuerpo del mensaje |
| `%d` | Refs (ramas/tags) que apuntan al commit |

### `bisect` para encontrar bugs

Búsqueda binaria entre un commit bueno y uno malo. Recorta de O(n) a O(log n) pruebas.

```bash
git bisect start
git bisect bad HEAD                 # el commit actual falla
git bisect good v1.0                # v1.0 funcionaba

# Git hace checkout a un commit intermedio. Pruebas:
git bisect good                     # funciona
git bisect bad                      # falla
# ... se repite hasta encontrar el culpable
git bisect reset                    # volver a la rama original
```

Modo automatizado con un script (0=bueno, otro=malo):

```bash
git bisect start HEAD v1.0
git bisect run ./test-bug.sh        # el script debe exit 0 si bueno
git bisect reset
```

Ejemplo de script:

```bash
#!/bin/bash
# test-bug.sh
npm test > /dev/null 2>&1 || exit 1
grep -q "resultado_esperado" out.txt || exit 1
exit 0
```

### Submodules

Un submodule embebe otro repositorio Git dentro del directorio de trabajo. Útil para compartir dependencias sin copiar código.

```bash
# Añadir
git submodule add https://github.com/lib/lib.git extern/lib
git commit -m "chore: añade lib como submodule"

# Clonar un repo con submodules
git clone --recurse-submodules https://github.com/yo/repo.git
# o si ya clonaste sin ellos:
git submodule update --init --recursive

# Actualizar submodules a su última versión
git submodule update --remote
git add extern/lib && git commit -m "chore: bump submodule lib"

# Cambiar de rama en un submodule
git -C extern/lib switch main

# Borrar un submodule
git submodule deinit -f extern/lib
git rm extern/lib
rm -rf .git/modules/extern/lib
```

El archivo `.gitmodules` registra la URL y el path de cada submodule:

```ini
[submodule "extern/lib"]
    path = extern/lib
    url = https://github.com/lib/lib.git
    branch = main
```

> ⚠️ Los submodules añaden complejidad (sincronizar versiones, estado detached). Considera alternativas: monorepo, paquetes del gestor de dependencias, o `git subtree`.

### sparse-checkout

Permite clonar el repo pero solo tener en el working dir un subconjunto de archivos. Ideal para monorepos gigantes.

```bash
git clone --no-checkout https://github.com/yo/monorepo.git
cd monorepo
git sparse-checkout init --cone
git sparse-checkout set apps/web apps/api
git checkout main

# Modo no-cone (patrones arbitrarios)
git sparse-checkout set --no-cone "src/*.md"
git sparse-checkout disable           # volver a checkout completo
```

### Worktrees

Un worktree es una carpeta de trabajo adicional vinculada al mismo `.git`. Permite tener varias ramas checkout a la vez sin clonar.

```bash
git worktree add ../repo-feature feature/login
# ahora tienes:
#   /repo               -> rama main
#   /repo-feature       -> rama feature/login
cd ../repo-feature
git worktree list                     # ver todos los worktrees
git worktree remove ../repo-feature   # borrar
git worktree prune                    # limpiar metadatos de worktrees borrados a mano
```

Casos de uso: hacer un hotfix urgente mientras tienes otra rama a medias; comparar dos versiones en paralelo; CI que necesita varios checkouts.

### Hooks

Los hooks son scripts que Git ejecuta automáticamente en ciertos eventos. Viven en `.git/hooks/` (no se versionan por defecto). Para compartirlos en el equipo, colócalos en una carpeta del repo y configura `core.hooksPath`.

```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

Hooks más usados:

| Hook | Cuándo se ejecuta | Uso típico |
|---|---|---|
| `pre-commit` | Antes de crear el commit | Lint, format, secretos |
| `pre-push` | Antes de `git push` | Tests, validar rama destino |
| `commit-msg` | Tras escribir el mensaje | Validar Conventional Commits |
| `prepare-commit-msg` | Antes de abrir el editor | Prellenar mensaje |
| `post-merge` | Tras un merge | Instalar dependencias |

Ejemplo `pre-commit` (lint con fallo = bloqueo):

```bash
#!/bin/bash
# .githooks/pre-commit
set -e
echo "Ejecutando lint..."
npx eslint . || { echo "❌ Lint falló. Arregla antes de commitear."; exit 1; }
echo "✅ Lint OK"
exit 0
```

Ejemplo `pre-push`:

```bash
#!/bin/bash
# .githooks/pre-push
# argumentos: <local ref> <local sha> <remote ref> <remote sha>
while read local_ref local_sha remote_ref remote_sha; do
  if [[ "$remote_ref" == "refs/heads/main" ]] || [[ "$remote_ref" == "refs/heads/develop" ]]; then
    echo "❌ No se puede pushear directamente a $remote_ref"
    exit 1
  fi
done
exit 0
```

### Git LFS (Large File Storage)

Git LFS sustituye archivos grandes (binarios, vídeos, modelos) por punteros ligeros en el repo, guardando el contenido real en un servidor LFS. Evita inflar el `.git`.

```bash
git lfs install                        # una vez por usuario
git lfs track "*.psd" "*.mp4" "*.zip"
# esto crea/actualiza .gitattributes
git add .gitattributes
git add archivo.psd
git commit -m "feat: añade asset con LFS"
git push

git lfs ls-files                       # ver archivos LFS tracked
git lfs pull                           # descargar contenido LFS
git lfs migrate import --include="*.psd"  # migrar historial existente
```

### Filtros clean/smudge y `.gitattributes`

Los filtros transforman archivos al entrar (clean) o salir (smudge) del repo. Casos típicos: normalizar finales de línea, ofuscar secretos, expandir variables.

```ini
# .gitattributes
# Normalizar finales de línea (LF en repo, nativo en checkout)
* text=auto
*.sh text eol=lf
*.bat text eol=crlf

# Marcar binarios (no diff)
*.png binary
*.pdf binary

# LFS
*.mp4 filter=lfs diff=lfs merge=lfs -text

# Lenguaje para GitHub linguist
*.h linguist-language=c
```

Filtro personalizado (ej: minificar JS al commitear):

```bash
git config filter.minify.clean  "terser --compress"
git config filter.minify.smudge "cat"
```

```ini
# .gitattributes
*.js filter=minify
```

### `blame` y `annotate`

```bash
git blame archivo.md              # autor+commit de cada línea
git annotate archivo.md           # alias legado
git blame -L 10,20 archivo.md     # solo líneas 10-20
git blame -w archivo.md           # ignorar cambios de espacios
git blame -C archivo.md           # seguir movimientos/copias entre archivos
git blame --first-parent          # simplificar merges
```

## Conceptos clave

| Concepto | Definición |
|---|---|
| **reset --soft/mixed/hard** | Mueve HEAD y opcionalmente staging/working |
| **revert** | Crea commit que invierte otro; seguro para historia pública |
| **reflog** | Registro local de movimientos de HEAD; red de seguridad |
| **bisect** | Búsqueda binaria del commit culpable |
| **submodule** | Repo embebido dentro de otro |
| **sparse-checkout** | Checkout parcial del árbol |
| **worktree** | Carpeta de trabajo adicional del mismo `.git` |
| **hook** | Script que Git ejecuta en un evento |
| **Git LFS** | Almacena archivos grandes fuera del `.git` |
| **.gitattributes** | Asigna atributos a rutas (text/binary, eol, LFS, filtros) |

## Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `reset --hard` borra cambios no commiteados | Modo hard descarta working dir | Usar `--soft`/`--mixed` si quieres conservar cambios |
| Commit "perdido" tras reset | Sigue en el reflog | `git reflog` → `git reset --hard <hash>` |
| `submodule` en estado detached HEAD | Checkout a commit, no a rama | `git -C <sub> switch main` o `git -C <sub> checkout -b main origin/main` |
| `fatal: remote origin already exists` | El remoto ya está configurado | `git remote set-url origin <url>` en vez de `add` |
| `pre-commit` no se ejecuta | Falta `chmod +x` o `core.hooksPath` | `chmod +x .githooks/*` y `git config core.hooksPath .githooks` |
| LFS no trackea archivos | Faltó `git lfs track` antes de `add` | Trackear, regenerar `.gitattributes` y re-add |
| `worktree` no permite checkout de la misma rama | La rama ya está checkout en otro sitio | Usar otra rama u otro worktree |
| `bisect` se cuelga | Script no termina | Asegurar `exit 0`/`exit 1` en el runner |
