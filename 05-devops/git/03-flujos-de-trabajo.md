# 03 — Flujos de trabajo

## Objetivos

- [ ] Conocer los modelos de ramas más usados: Git Flow, GitHub Flow, Trunk-based
- [ ] Hacer rebase interactivo para reescribir el historial
- [ ] Agrupar commits con squash
- [ ] Mover commits entre ramas con cherry-pick
- [ ] Crear tags anotados y ligeros, y publicarlos
- [ ] Usar `reflog` para recuperar estados perdidos
- [ ] Guardar cambios temporales con `stash`
- [ ] Averiguar quién introdujo un cambio con `blame`
- [ ] Cazar bugs con `bisect`
- [ ] Escribir commits siguiendo Conventional Commits y Conventional Comments

## Apuntes

### Modelos de ramas

La elección del flujo depende del tamaño del equipo, la cadencia de release y si hay soporte a versiones antiguas en producción.

#### Git Flow (Vincent Driessen)

Modelo con ramas fijas y de soporte. Apto para proyectos con releases versionados y soporte a versiones antiguas.

| Rama | Origen | Destino | Propósito |
|---|---|---|---|
| `main` | — | — | Código en producción, cada commit es una release |
| `develop` | `main` | `main` | Integración de features |
| `feature/*` | `develop` | `develop` | Nuevas funcionalidades |
| `release/*` | `develop` | `main` + `develop` | Preparar una release |
| `hotfix/*` | `main` | `main` + `develop` | Arreglar un bug urgente en producción |

```bash
git flow init
git flow feature start login
# trabajar...
git flow feature finish login
git flow release start 1.2.0
git flow release finish 1.2.0
git flow hotfix start fix-login 1.1.0
git flow hotfix finish fix-login
```

#### GitHub Flow

Más simple: una rama `main` siempre desplegable y ramas de feature de vida corta. Ideal para despliegue continuo.

1. `main` siempre desplegable.
2. Rama `feature/*` desde `main`.
3. Commits + push.
4. Pull Request → revisión + CI.
5. Merge a `main` → despliegue automático.
6. Borrar la rama.

#### Trunk-based development

Todos trabajan sobre `main` (el *trunk*), integrando varias veces al día. Las features grandes se ocultan con *feature flags*. Excelente para CI/CD y equipos maduros.

- Ramas de vida muy corta (<1 día).
- Rebase antes de integrar para mantener historia lineal.
- *Feature flags* para código a medio terminar.

| Criterio | Git Flow | GitHub Flow | Trunk-based |
|---|---|---|---|
| # ramas fijas | 2 + soporte | 1 | 1 |
| Releases | versionadas | continuas | continuas |
| Hotfixes | rama dedicada | desde main | desde main |
| Complejidad | Alta | Baja | Baja |
| Ideal para | Librerías, on-premise | SaaS | SaaS / alto CD |

### Rebase interactivo

El rebase vuelve a aplicar tus commits uno a uno sobre otra base. En modo interactivo, además, permite reescribirlos: reordenar, editar, squashear, cambiar mensaje.

```bash
git rebase -i HEAD~3            # reescribe los últimos 3 commits
git rebase -i main             # rebasa la rama actual sobre main
git rebase -i --root           # desde el primer commit del repo
```

Se abre el editor con una lista. Primera columna = acción:

| Acción | Efecto |
|---|---|
| `pick` (p) | Conservar el commit tal cual |
| `reword` (r) | Cambiar el mensaje del commit |
| `edit` (e) | Pausar para modificar el commit (añadir archivos, dividir) |
| `squash` (s) | Fusionar con el commit anterior (pide mensaje combinado) |
| `fixup` (f) | Como squash pero descarta el mensaje del commit |
| `drop` (d) | Eliminar el commit |
| `reorder` | Mover líneas para reordenar commits |

```
pick   3f2a1b0 feat: añade login
reword 8c4d2e9 feat: añade registro        # cambiar el mensaje
squash a1b2c3d wip                          # fusionar con el anterior
fixup  4e5f6a7 typo                          # fusionar y descartar mensaje
drop   9z8y7x6 commit roto                   # eliminar
```

```bash
git rebase --continue         # tras resolver un conflicto
git rebase --skip             # saltar un commit conflictivo
git rebase --abort            # cancelar y volver al estado inicial
```

> ⚠️ **Regla de oro del rebase:** nunca rebasar commits que ya has publicado (push) en una rama compartida. Reescribe hashes y rompe a quien ya los tiene.

### Squash

Agrupar varios commits en uno. Dos vías:

```bash
# Vía 1: rebase interactivo con squash/fixup
git rebase -i HEAD~3
# cambiar a "squash" o "fixup" las líneas 2 y 3

# Vía 2: reset soft + nuevo commit (rama no publicada)
git reset --soft HEAD~3
git commit -m "feat: implementa login completo"
```

### Cherry-pick

Aplica un commit concreto sobre la rama actual. Útil para llevar un hotfix a varias ramas de release.

```bash
git cherry-pick a1b2c3d              # aplicar un commit
git cherry-pick a1b2c3d 4e5f6a7      # varios
git cherry-pick main..feature        # un rango (exclusivo)
git cherry-pick --no-commit a1b2c3d  # aplicar cambios al staging sin commitear
git cherry-pick --abort              # cancelar
```

### Tags

Los tags marcan puntos concretos del historial, típicamente releases (`v1.0.0`).

| Tipo | Comando | Características |
|---|---|---|
| **Ligero** | `git tag v1.0` | Solo un puntero a un commit |
| **Anotado** | `git tag -a v1.0 -m "Release 1.0"` | Almacena autor, fecha, mensaje y checksum |

```bash
git tag                               # listar
git tag -l "v1.*"                     # filtrar
git tag v1.0                          # tag ligero
git tag -a v1.0 -m "Release 1.0.0"   # tag anotado (recomendado)
git tag -a v1.0 a1b2c3d -m "..."      # tag sobre un commit pasado
git show v1.0                         # ver info del tag
git push origin v1.0                  # subir un tag
git push origin --tags                # subir todos los tags
git tag -d v1.0                       # borrar local
git push origin --delete v1.0         # borrar remoto
```

> Los tags **no se suben con `git push` normal**; hay que subirlos explícitamente.

### `reflog`: el historial de movimientos

El reflog registra **todos los movimientos de HEAD y las ramas**, incluso commits que creías perdidos (amend, reset --hard, rebase). Es tu red de seguridad local.

```bash
git reflog                  # historial de HEAD
git reflog --all            # de todas las refs
git reflog show feature     # de una rama concreta
# Recuperar un estado "perdido"
git reset --hard HEAD@{2}   # volver a donde estaba HEAD hace 2 movimientos
git reset --hard a1b2c3d    # volver a un commit por hash
```

### `stash`: guardar cambios temporalmente

Guarda cambios sin commitear y limpia el working dir. Útil antes de cambiar de rama o hacer pull.

```bash
git stash                       # guardar cambios tracked
git stash -u                    # incluir archivos untracked
git stash -a                    # incluir archivos ignorados
git stash save "mensaje"        # (legacy) con mensaje
git stash push -m "wip login"   # (moderno) con mensaje
git stash list                  # ver stashes guardados
git stash show -p stash@{0}     # ver el diff de un stash
git stash pop                   # aplicar el último y borrarlo
git stash apply stash@{1}       # aplicar sin borrar
git stash drop stash@{0}        # borrar un stash
git stash clear                 # borrar todos
```

### `blame`: quién escribió cada línea

```bash
git blame README.md                 # autor y commit de cada línea
git blame -L 10,20 README.md        # solo líneas 10-20
git blame -w README.md              # ignorar cambios de espacios en blanco
git blame -C README.md              # seguir movimientos entre archivos
git blame --since="3 weeks ago" README.md
```

### `bisect`: cazar el commit que introdujo un bug

Búsqueda binaria sobre el historial entre un commit bueno y uno malo.

```bash
git bisect start
git bisect bad                    # el commit actual es malo (tiene el bug)
git bisect good v1.0              # v1.0 funcionaba bien
# Git hace checkout a un commit del medio
# ... pruebas ...
git bisect good                   # o git bisect bad
# tras varias iteraciones, Git anuncia el commit culpable
git bisect reset                  # volver a la rama original
```

Automatizado: Git ejecuta un comando y decide bueno/malo por el código de salida.

```bash
git bisect start HEAD v1.0
git bisect run npm test           # 0=bueno, otro=malp
git bisect reset
```

### Conventional Commits

Especificación para escribir mensajes de commit estructurados, legibles por máquinas y base para changelogs y versionado automáticos.

Formato: `tipo(ámbito): descripción`

| Tipo | Uso |
|---|---|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `docs` | Solo documentación |
| `style` | Formato (puntos y comas, espacios); no cambia código |
| `refactor` | Ni feat ni fix |
| `perf` | Mejora de rendimiento |
| `test` | Añadir/corregir tests |
| `build` | Sistema de build, dependencias |
| `ci` | Configuración de CI |
| `chore` | Tareas de mantenimiento |
| `revert` | Revertir un commit |

```
feat(auth): añade login con OAuth2

Permite a los usuarios iniciar sesión con Google y GitHub.
Se añade el flujo de PKCE y se refresca el token automáticamente.

Closes #142
```

Reglas:

- `!` indica breaking change: `feat(api)!: renombra endpoint /users a /account`.
- Pie `BREAKING CHANGE: descripción` para detalles.
- Referencias: `Closes #123`, `Refs #456`.

### Conventional Comments

Convención para **comentarios de code review** que los hace más claros y parseables.

Formato: `etiqueta: comentario (n, contexto)`

| Etiqueta | Significado |
|---|---|
| `praise:` | Destacar algo bueno |
| `nitpick:` | Detalle menor, no bloqueante |
| `suggestion:` | Propuesta de mejora |
| `issue:` | Problema real, debe arreglarse |
| `question:` | Pregunta para el autor |
| `thought:` | Reflexión abierta |
| `chore:` | Tarea pequeña |

Ejemplo: `suggestion: extrae esta lógica a una función (n, performance)`

## Conceptos clave

| Concepto | Definición |
|---|---|
| **Git Flow** | Modelo con main/develop/feature/release/hotfix |
| **Trunk-based** | Todos integran en main varias veces al día |
| **Rebase** | Vuelve a aplicar commits sobre otra base |
| **Squash** | Agrupar varios commits en uno |
| **Cherry-pick** | Aplicar un commit aislado sobre otra rama |
| **Tag** | Marca un punto del historial (release) |
| **Reflog** | Registro local de movimientos de HEAD; red de seguridad |
| **Stash** | Pila de cambios guardados temporalmente |
| **Bisect** | Búsqueda binaria del commit culpable de un bug |
| **Conventional Commits** | Especificación de mensajes de commit |

## Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `CONFLICT` en rebase | Mismas líneas cambiadas | Resolver, `git add`, `git rebase --continue` |
| `fatal: It seems that there is already a rebase-merge directory` | Rebase a medias | `git rebase --abort` y reiniciar |
| Tag no aparece en GitHub | Olvidaste subir el tag | `git push origin <tag>` o `--tags` |
| `error: cannot rebase: You have unstaged changes` | Cambios sin commitear | `git stash` antes de rebase |
| `bisect run` se desmadra | Script no devuelve 0/1 consistente | Asegurar `exit 0`/`exit 1` |
| Commit perdido tras `reset --hard` | Se quitó de la rama, pero sigue en reflog | `git reflog` y `git reset --hard <hash>` |
| `cherry-pick` genera conflicto | El commit no aplica limpio | Resolver, `git add`, `git cherry-pick --continue` |
| Mensaje de commit sin verbo | Estilo poco claro | Usar imperativo: "añade", "corrige" |
