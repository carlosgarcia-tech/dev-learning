# Proyecto Final — Gestión de un repositorio con Git Flow y CI

## Contexto

Imagina que lideras el desarrollo de una pequeña aplicación (`app`) que sigue un ciclo de releases versionado. Tu equipo ha decidido adoptar **Git Flow** como modelo de ramas, complementado con **Conventional Commits**, **hooks de pre-commit** (lint), **tags de release** y un **changelog automático**. El repositorio trabaja contra un **remote simulado** (un repo bare local).

Este proyecto integrador pone a prueba todo lo aprendido en los niveles 1–5: fundamentos, ramas, remotos, flujos de trabajo, rebase, hooks, tags, conventional commits y mantenimiento del repo.

## Objetivos

- [ ] Aplicar Git Flow completo: `main`, `develop`, `feature`, `release`, `hotfix`.
- [ ] Configurar un hook `pre-commit` que ejecuta un lint y bloquea commits con secretos.
- [ ] Escribir commits siguiendo Conventional Commits.
- [ ] Generar un `CHANGELOG.md` automático a partir de los commits.
- [ ] Crear tags anotados para cada release.
- [ ] Sincronizar el repo local con un remote simulado (bare).
- [ ] Integrar un pipeline de CI simulado que corre al hacer push.

## Estructura esperada

```
proyectos/
├── README.md                 # este documento
├── setup.sh                  # crea el repo inicial + remote simulado
├── test.sh                   # valida el proyecto completo
├── starter/                  # archivos de partida
│   ├── .githooks/
│   │   ├── pre-commit        # lint + bloqueo de secrets
│   │   └── commit-msg        # valida Conventional Commits
│   ├── scripts/
│   │   └── generate-changelog.sh   # genera CHANGELOG.md desde git log
│   └── app/
│       └── main.js           # código base
└── solucion/
    └── solucion.sh           # solución completa de referencia
```

## Requisitos funcionales

### 1. Git Flow
- [ ] Rama `main` (producción) y `develop` (integración).
- [ ] Al menos una rama `feature/*` fusionada en `develop` (merge --no-ff).
- [ ] Al menos una rama `release/*` fusionada en `main` y `develop`.
- [ ] Al menos una rama `hotfix/*` fusionada en `main` y `develop`.

### 2. Hooks
- [ ] `.githooks/pre-commit` bloquea commitear archivos `*.env` y `secrets.*`.
- [ ] `.githooks/commit-msg` valida que el mensaje siga Conventional Commits.
- [ ] `core.hooksPath` configurado a `.githooks`.

### 3. Conventional Commits
- [ ] Todos los commits usan el formato `tipo(ámbito): descripción`.
- [ ] Al menos un `feat:`, un `fix:` y un `docs:`.

### 4. Changelog automático
- [ ] `scripts/generate-changelog.sh` lee `git log` y genera `CHANGELOG.md` agrupado por tipo.
- [ ] `CHANGELOG.md` está commiteado en `main`.

### 5. Tags de release
- [ ] Tag anotado `v1.0.0` sobre el commit de release en `main`.
- [ ] Tag anotado `v1.0.1` sobre el commit de hotfix en `main`.

### 6. Remote simulado
- [ ] Existe un remote `origin` apuntando a un repo bare local.
- [ ] `main` y `develop` están subidas al remote.
- [ ] Los tags están subidos al remote.

### 7. CI simulado
- [ ] Un script `ci.sh` que ejecuta `lint` + `tests` y devuelve 0 si todo OK.
- [ ] El hook `pre-push` (opcional) ejecuta `ci.sh` antes de允许 push.

## Fases

### Fase 1 — Inicialización
- Ejecuta `setup.sh` para crear el repo y el remote.
- Copia los archivos de `starter/` al repo.
- Configura `user.name`, `user.email`, `core.hooksPath`.

### Fase 2 — Feature
- Crea `develop` desde `main`.
- Crea `feature/auth`, añade `app/auth.js`, commitea `feat(auth): añade autenticación`.
- Fusiona en `develop` con `--no-ff`.

### Fase 3 — Release
- Crea `release/1.0.0` desde `develop`.
- Genera `CHANGELOG.md` con `scripts/generate-changelog.sh`.
- Commitea `docs: genera changelog 1.0.0`.
- Fusiona release en `main` y `develop`.
- Crea tag anotado `v1.0.0`.

### Fase 4 — Hotfix
- Crea `hotfix/1.0.1` desde `main`.
- Corrige un bug en `app/main.js`, commitea `fix(app): corrige bug crítico`.
- Fusiona hotfix en `main` y `develop`.
- Crea tag anotado `v1.0.1`.

### Fase 5 — Remote y CI
- Añade el remote simulado como `origin`.
- Sube `main`, `develop` y los tags.
- Verifica que `ci.sh` pasa.

## Criterios de aceptación

- [ ] `bash test.sh` imprime `OK Tests pasaron` (exit 0).
- [ ] El historial de `main` contiene commits `feat:`, `fix:` y `docs:`.
- [ ] `main` y `develop` están sincronizadas con el remote.
- [ ] Los tags `v1.0.0` y `v1.0.1` existen local y remotamente.
- [ ] El hook `pre-commit` bloquea efectivamente los `*.env`.
- [ ] `CHANGELOG.md` existe y contiene secciones Features y Bug Fixes.

## Cómo ejecutar

```bash
cd 05-devops/git/ejercicios/proyectos
bash test.sh
```

El `test.sh` ejecuta `setup.sh`, aplica la solución de referencia (`solucion/solucion.sh`) y verifica todos los criterios.
