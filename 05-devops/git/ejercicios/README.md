# Ejercicios — Git

Cada ejercicio es una **carpeta** con: `README.md` (enunciado + requisitos + pistas y solución plegables), `setup.sh` (crea un repositorio temporal aislado con `mktemp -d`), `solucion/solucion.sh` (solución con comandos git) y `test.sh` (verifica el estado del repo resultante con `git`).

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-init-y-primer-commit
bash test.sh        # crea un repo temporal con setup.sh, aplica la solución y verifica el estado
```

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | init y primer commit, add y commit, log y diff, .gitignore, clonar y modificar, estado de archivos | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | crear y cambiar ramas, merge simple, resolver conflicto, remote y push, pull y fetch, tag | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | rebase, squash commits, cherry-pick, stash, reset y revert, blame y bisect | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | rebase interactivo, submodules, hooks pre-commit, worktrees, reflog y recuperación, sparse-checkout | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | Git Flow completo, conventional commits y changelog, firma GPG, bisect automatizado, merge strategy monorepo, limpieza gc/prune/fsck | ⬜ |
| [proyectos](proyectos/) | Proyecto final: Git Flow + CI | ⬜ |
