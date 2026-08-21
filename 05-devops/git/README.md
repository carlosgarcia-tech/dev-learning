# Git

> Guía de estudio + ejercicios por niveles para aprender Git desde cero hasta nivel experto.

Git es el sistema de control de versiones distribuido más usado del mundo. Esta sección cubre desde la instalación y configuración inicial hasta flujos de trabajo avanzados, rebase interactivo, submodules, hooks, firmado GPG y resolución de problemas. Todos los ejemplos y ejercicios funcionan con la CLI de **git** instalada localmente, y los `test.sh` crean repositorios temporales aislados con `mktemp -d` para verificar el estado resultante.

## Cómo usar esta sección

1. Lee las **guías** en orden: `01-fundamentos` → `02-ramas-y-remotos` → `03-flujos-de-trabajo` → `04-avanzado` → `05-colaboracion-y-buenas-practicas`.
2. Resuelve los **ejercicios** de cada nivel antes de pasar al siguiente.
3. Ejecuta cada ejercicio localmente: cada carpeta tiene `setup.sh` (crea un repo temporal preconfigurado), `solucion/solucion.sh` (la solución) y un `test.sh` con `set -euo pipefail` que verifica el estado del repo resultante con `git log`/`git branch`/`git show`.
4. Al final, completa el **proyecto integrador**: un repositorio con Git Flow, hooks, tags, conventional commits y changelog automático.

## Guías

| # | Guía | Contenido |
|---|---|---|
| 1 | [01-fundamentos.md](01-fundamentos.md) | Qué es control de versiones, git vs otros VCS, instalación, `git config`, `init`/`clone`, estados, `add`/`commit`, `log`, `diff`, `.gitignore`, HEAD |
| 2 | [02-ramas-y-remotos.md](02-ramas-y-remotos.md) | Ramas, `branch`/`checkout`/`switch`, `merge`, conflictos, fast-forward vs merge commit, `remote`/`fetch`/`pull`/`push`, tracking, `fork` vs `clone` |
| 3 | [03-flujos-de-trabajo.md](03-flujos-de-trabajo.md) | Git Flow, GitHub Flow, Trunk-based, rebase interactivo, squash, cherry-pick, tags, reflog, stash, blame, bisect, conventional commits |
| 4 | [04-avanzado.md](04-avanzado.md) | `reset` soft/mixed/hard, `revert` vs `reset`, reflog, `log` avanzado, bisect, submodules, sparse-checkout, worktrees, hooks, LFS, `.gitattributes` |
| 5 | [05-colaboracion-y-buenas-practicas.md](05-colaboracion-y-buenas-practicas.md) | Pull requests, code review, squash merge, monorepo, protección de ramas, releases y changelog, CI, troubleshooting `gc`/`prune`/`fsck`, firma GPG, seguridad |

## Ejercicios

Cada ejercicio es una **carpeta** con: `README.md` (enunciado + requisitos + pistas + solución plegables), `setup.sh` (crea un repositorio temporal aislado con `mktemp -d`), `solucion/solucion.sh` (solución con comandos git) y `test.sh` (verifica el estado del repo resultante con `git`).

| Nivel | Qué cubre | Enlaces |
|---|---|---|
| Nivel 1 — Fundamentos | init y primer commit, add y commit, log y diff, .gitignore, clonar y modificar, estado de archivos | [ejercicios/nivel-01-fundamentos/](ejercicios/nivel-01-fundamentos/) |
| Nivel 2 — Básico | crear y cambiar ramas, merge simple, resolver conflicto, remote y push, pull y fetch, tag | [ejercicios/nivel-02-basico/](ejercicios/nivel-02-basico/) |
| Nivel 3 — Intermedio | rebase, squash commits, cherry-pick, stash, reset y revert, blame y bisect | [ejercicios/nivel-03-intermedio/](ejercicios/nivel-03-intermedio/) |
| Nivel 4 — Avanzado | rebase interactivo, submodules, hooks pre-commit, worktrees, reflog y recuperación, sparse-checkout | [ejercicios/nivel-04-avanzado/](ejercicios/nivel-04-avanzado/) |
| Nivel 5 — Experto | Git Flow completo, conventional commits y changelog, firma GPG, bisect automatizado, merge strategy monorepo, limpieza gc/prune/fsck | [ejercicios/nivel-05-experto/](ejercicios/nivel-05-experto/) |

## Proyecto integrador

| Proyecto | Descripción |
|---|---|
| [Proyecto final: Git Flow + CI](ejercicios/proyectos/) | Configurar un repo con Git Flow (main, develop, feature, release, hotfix), hooks de pre-commit (lint), tags de release, conventional commits, changelog automático e integración con remote simulado |

## Cómo ejecutar un ejercicio

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-init-y-primer-commit
bash test.sh        # crea un repo temporal con setup.sh, aplica la solución y verifica el estado
```

## Requisitos previos

- `git` instalado (`git --version`).
- `bash` 4+ (para `mktemp -d` y arrays).
- Opcional para ejercicios avanzados: soporte de `git lfs`, `gpg`/`gpg2`.
