# 01 — Fundamentos de CI/CD

## Objetivos

- [ ] Entender qué es CI, CD (*Continuous Delivery*) y CD (*Continuous Deployment*) y la diferencia entre los tres.
- [ ] Conocer el concepto de *pipeline*, sus *stages* y *jobs*, y cómo se ordenan y ejecutan.
- [ ] Distinguir los *triggers* (push, pull request, schedule, manual, tag) y cuándo usar cada uno.
- [ ] Saber qué son los *artifacts* y para qué sirven (compartir resultados entre jobs).
- [ ] Entender el *cache* de dependencias y por qué acelera los pipelines.
- [ ] Conocer los *runners* (hosted vs self-hosted) y el modelo de ejecución aislada.
- [ ] Leer un pipeline en YAML e identificar sus partes (trigger, jobs, steps, actions).
- [ ] Escribir un pipeline mínimo que ejecute un comando y guarde un artifact.
- [ ] Identificar los errores más comunes al diseñar pipelines.

## Apuntes

### ¿Qué es CI/CD?

CI/CD es un conjunto de prácticas y herramientas que **automatizan** la integración, verificación y entrega del código. El acrónimo cubre tres conceptos distintos:

| Término | Significado | ¿Qué automatiza? |
|---|---|---|
| **CI** | Continuous Integration (Integración Continua) | Compilar + testear cada cambio que llega al repo. |
| **CD** | Continuous Delivery (Entrega Continua) | CI + preparar el artefacto desplegable (siempre listo para publicar). |
| **CD** | Continuous Deployment (Despliegue Continuo) | CD (Delivery) + desplegar automáticamente a producción sin intervención humana. |

> El truco para no confundir los dos "CD": en **Delivery** el despliegue a producción requiere un *clic* (aprobación manual); en **Deployment** cada cambio verde se despliega solo. La diferencia es esa *gate* manual.

El flujo clásico:

```
        push/PR            build          test           package          deploy
desarrollador  ──►  CI (integración)  ──►  CI (verificación)  ──►  CD (entrega)  ──►  CD (despliegue)
                                                                        │ gate manual (Delivery)
                                                                        └── automática (Deployment)
```

#### Beneficios

- **Detectar errores pronto**: cada commit se prueba, no se acumulan rotos.
- **Reproducibilidad**: el mismo pipeline corre en tu máquina y en el servidor.
- **Confianza para desplegar**: si el pipeline está verde, producción *debería* ir bien.
- **Trazabilidad**: cada artefacto se vincula al commit y al pipeline que lo generó.
- **Feedback rápido**: los tests corren en paralelo y en minutos.

### El pipeline

Un *pipeline* es una secuencia ordenada de etapas (*stages*) que ejecutan trabajos (*jobs*). Cada job contiene *steps* (comandos o llamadas a *actions*). Es la unidad de automatización.

```yaml
# Esquema genérico (notación tipo GitHub Actions)
name: CI                         # nombre del pipeline
on: push                         # trigger: cuándo se ejecuta
jobs:                            # conjunto de trabajos
  build:                         # job
    runs-on: ubuntu-latest        # runner (máquina)
    steps:                        # pasos del job
      - uses: actions/checkout@v4 # action reutilizable
      - run: echo "Compilando..." # comando
```

Estructura jerárquica:

```
pipeline (workflow)
└── jobs (trabajos, se ejecutan en paralelo por defecto)
    └── steps (pasos secuenciales dentro de un job)
        ├── uses: <action>      # acción reutilizable
        └── run: <comando>       # comando de shell
```

### Stages y jobs

- **Stage** (etapa) es una agrupación lógica: *build*, *test*, *deploy*. En GitLab CI es un concepto explícito; en GitHub Actions se modela con `needs` entre jobs.
- **Job** es la unidad que se ejecuta en un *runner*. Dentro de un stage los jobs corren en paralelo; entre stages, en secuencia.

| Concepto | GitHub Actions | GitLab CI |
|---|---|---|
| Pipeline | `workflow` (archivo en `.github/workflows/`) | pipeline (archivo `.gitlab-ci.yml`) |
| Job | `jobs.<id>` | claves de raíz del YAML |
| Stage | agrupación con `needs` | `stages:` + `stage:` por job |
| Step | `steps:` | `script:` (lista de comandos) |
| Runner | `runs-on:` | `tags:` / runner compartido |
| Trigger | `on:` | `rules:` / `only:` / `workflow:` |

Ejemplo GitLab CI con stages explícitos:

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - echo "Compilando la app"
    - make build

test_unit:
  stage: test
  script:
    - make test

test_lint:
  stage: test            # mismo stage que test_unit → corren en paralelo
  script:
    - make lint

deploy_prod:
  stage: deploy
  script:
    - echo "Desplegando"
  only:
    - main
```

> En GitLab, los jobs del mismo `stage` corren en paralelo y un stage no empieza hasta que terminan todos los jobs del anterior (salvo `needs:` explícito).

### Triggers

El *trigger* define **cuándo** se ejecuta el pipeline.

| Trigger | GitHub Actions (`on:`) | GitLab CI | Caso de uso |
|---|---|---|---|
| Push a rama | `push` | push por defecto | CI en cada commit |
| Pull request | `pull_request` | regla `if: $CI_PIPELINE_SOURCE == "merge_request_event"` | Verificar antes de merge |
| Etiqueta/tag | `workflow_dispatch`/`push: tags` | `if: $CI_COMMIT_TAG` | Releases |
| Programado | `schedule` | `schedules:` | Nightly builds, escaneos |
| Manual | `workflow_dispatch` | `when: manual` | Despliegues a producción |
| Evento externo | `repository_dispatch` | webhook/API trigger | Disparar desde otro sistema |

GitHub Actions, ejemplos:

```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: "0 3 * * *"        # nightly a las 03:00 UTC
  workflow_dispatch:           # botón "Run workflow" manual
    inputs:
      entorno:
        description: "Entorno destino"
        required: true
        default: staging
```

GitLab CI con `rules` (forma moderna y recomendada):

```yaml
workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"
    - if: $CI_COMMIT_TAG

deploy_prod:
  rules:
    - if: $CI_COMMIT_TAG
```

### Artifacts

Un *artifact* es un archivo o carpeta que un job **guarda** para que otros jobs (o el usuario) lo descarguen. Sin artifacts, cada job empieza desde cero: lo que produce un job no viaja al siguiente.

```yaml
# GitHub Actions: guardar y bajar artifacts
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: make build
      - uses: actions/upload-artifact@v4   # sube la carpeta
        with:
          name: binario
          path: dist/
          retention-days: 7

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: binario
          path: dist/
      - run: make test
```

GitLab CI equivalente:

```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week

test:
  stage: test
  needs: [build]
  script:
    - make test
```

> Ojo: en GitLab los artifacts del stage anterior se pasan automáticamente a los jobs del siguiente stage (salvo `dependencies: []`); en GitHub Actions hay que subirlos y bajarlos a mano con las actions `upload-artifact` / `download-artifact`.

### Cache

El *cache* guarda dependencias entre ejecuciones para no descargarlas cada vez. A diferencia del artifact, el cache es **opaco al usuario** y se reutiliza entre *runs* del mismo workflow.

```yaml
# GitHub Actions: cache de npm
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-
```

Atajo específico para cada lenguaje:

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: 'npm'           # cachea node_modules automáticamente
```

GitLab CI con `cache`:

```yaml
cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/

install:
  script:
    - npm ci
```

| | Cache | Artifact |
|---|---|---|
| Propósito | Acelerar (reutilizar dependencias) | Transferir resultados entre jobs |
| Caducidad | Por `key`, se invalida si cambia | `retention-days` / `expire_in` |
| Visible al usuario | No (interno) | Sí (descargable) |
| Ejemplo típico | `node_modules`, `~/.m2` | `dist/`, binarios, reportes |

### Runners

Un *runner* es la máquina (o contenedor) que ejecuta el job. Puede ser gestionado por la plataforma o propio.

| Tipo | GitHub Actions | GitLab CI |
|---|---|---|
| Gestionado (cloud) | `ubuntu-latest`, `windows-latest`, `macos-latest` | runners compartidos en GitLab.com |
| Self-hosted | `runs-on: [self-hosted, linux]` | `tags: [self-hosted, linux]` |
| Docker | imagen del runner | `image: node:20` en el job |

```yaml
# GitHub Actions self-hosted
jobs:
  build:
    runs-on: [self-hosted, linux, x64]
```

```yaml
# GitLab CI con imagen Docker
test:
  image: node:20-alpine
  script:
    - npm ci
    - npm test
```

> Regla de oro: el runner debe ser **desechable**. Si un job depende de un estado previo en la máquina, ese estado se romperá. Trata cada job como si corriera en una máquina recién instalada.

### CI vs CD vs CD: el matiz que importa

```
┌──────────────┬──────────────────────────┬──────────────────────────┬──────────────────────────┐
│              │  Continuous Integration  │  Continuous Delivery     │  Continuous Deployment   │
├──────────────┼──────────────────────────┼──────────────────────────┼──────────────────────────┤
│ ¿Compila?    │  sí                      │  sí                      │  sí                      │
│ ¿Pasa tests? │  sí                      │  sí                      │  sí                      │
│ ¿Artefacto?  │  tal vez                 │  sí, listo para publicar  │  sí, publicado           │
│ ¿Despliega?  │  no                      │  a staging/manual a prod │  automático a producción │
│ Gate a prod  │  —                       │  aprobación manual       │  ninguna (verde → prod)  │
└──────────────┴──────────────────────────┴──────────────────────────┴──────────────────────────┘
```

- **CI** solo asegura que el código se integra y verifica. No produce artefacto desplegable.
- **Delivery** garantiza que siempre hay un artefacto *listo* para producción; publicar requiere un clic.
- **Deployment** elimina el clic: cada commit verde llega a producción. Solo lo usan equipos maduros con mucha observabilidad y *feature flags*.

### Pipeline mínimo completo (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm test
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/
```

### Pipeline mínimo completo (GitLab CI)

```yaml
# .gitlab-ci.yml
image: node:20-alpine
stages: [test]

test:
  stage: test
  cache:
    key:
      files: [package-lock.json]
    paths: [node_modules/]
  script:
    - npm ci
    - npm test
  artifacts:
    paths: [coverage/]
    expire_in: 1 week
```

## Tablas de referencia

### Glosario

| Término | Definición |
|---|---|
| Pipeline | Secuencia automatizada de stages y jobs que integra y entrega código. |
| Stage | Agrupación lógica de jobs (build, test, deploy). |
| Job | Unidad que se ejecuta en un runner. |
| Step | Paso dentro de un job (comando o action). |
| Action | Unidad reutilizable de GitHub Actions (en GitHub Marketplace). |
| Trigger / Event | Suceso que dispara el pipeline (push, PR, tag, schedule). |
| Artifact | Archivo que un job guarda para otros jobs o para descargar. |
| Cache | Dependencias reutilizadas entre runs para acelerar. |
| Runner | Máquina o contenedor que ejecuta el job. |
| Gate | Punto de aprobación (manual o automático) que detiene el pipeline. |
| Environment | Entorno lógico de despliegue (dev, staging, prod) con reglas y secrets. |
| Matrix | Estrategia que ejecuta el mismo job con varias combinaciones de variables. |

### Extensiones de archivo

| Archivo | Plataforma | Propósito |
|---|---|---|
| `.github/workflows/*.yml` | GitHub Actions | Definición de workflows. |
| `.gitlab-ci.yml` | GitLab CI | Definición del pipeline. |
| `Dockerfile` | Docker / ambos | Imagen base para jobs o para desplegar. |

## Conceptos clave

- **Pipeline = secuencia automática**. Un pipeline debe ser reproducible y no depender de estado externo: si lo reinicias, llega al mismo resultado.
- **CI primero, CD después**. No intentes desplegar automáticamente a producción antes de tener verde y confiable el CI.
- **Artifacts vs cache**: el artifact transfiere resultados entre jobs; el cache acelera runs reutilizando dependencias. No los mezcles.
- **Runners desechables**: cada job se ejecuta en un entorno limpio. Si necesitas estado, usa artifacts o cache explícito.
- **El trigger lo decide todo**. Elegir mal el trigger dispara pipelines cuando no toca o no los dispara cuando hace falta.
- **El acrónimo "CD" es ambiguo**: siempre aclara si hablas de Delivery o de Deployment.

## Errores comunes

- **Olvidar el `checkout`** (GitHub Actions): el runner no trae el código por defecto; sin `actions/checkout` los comandos fallan con "file not found".
- **Asumir que el estado pasa entre jobs**: en GitHub Actions cada job empieza limpio; hay que subir/bajar artifacts a propósito.
- **No invalidar el cache**: una `key` estática hace que el cache nunca se renueve. Usa `hashFiles()` (GitHub) o `key.files:` (GitLab) en la clave.
- **Poner todo en un solo job gigante**: pierdes paralelismo y empeora el diagnóstico. Divide por responsabilidad (build, test, lint).
- **Desplegar a producción sin gate en Delivery**: confundir Delivery con Deployment y acabar publicando cada commit verde a producción.
- **Triggers demasiado anchos**: `[push]` sin filtrar por rama dispara el pipeline en cada rama de feature, gastando minutos de runner.
- **Secrets en texto plano en el YAML**: los secrets van en `secrets.` (GitHub) o `variables` protegidas (GitLab), nunca escritos en el pipeline.
- **No cachear dependencias**: cada run reinstala todo y el pipeline pasa de 1 min a 10 min.
- **Jobs sin `needs` que dependen entre sí**: el job B que usa la salida de A sin `needs: A` corre en paralelo y falla porque A aún no terminó.
- **Ignorar el `fail-fast` de la matrix**: un job rojo cancela los demás y no ves todos los fallos. Usa `fail-fast: false` cuando quieras ver el panorama completo.
