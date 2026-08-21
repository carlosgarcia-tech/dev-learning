# 03 — GitLab CI

## Objetivos

- [ ] Entender el modelo de GitLab CI y dónde vive su configuración (`.gitlab-ci.yml`).
- [ ] Definir `stages` y asignar jobs a un `stage` concreto.
- [ ] Escribir jobs con `script`, `before_script`, `after_script` y `image`.
- [ ] Controlar la ejecución con `rules`, `only/except` y variables predefinidas.
- [ ] Usar `artifacts` y `cache` para transferir resultados y acelerar runs.
- [ ] Gestionar variables (`variables`) protegidas y enmascaradas.
- [ ] Configurar runners compartidos y *self-hosted* con `tags`.
- [ ] Ejecutar jobs dentro de imágenes Docker (`image:`).
- [ ] Encadenar jobs con `needs` y dependencias de artifacts (`dependencies`).
- [ ] Reutilizar configuración con `include`, plantillas y `hidden jobs`.

## Apuntes

### El modelo de GitLab CI

GitLab CI lee el archivo `.gitlab-ci.yml` en la raíz del repo. Define un *pipeline* con *stages* y *jobs*. Cada job corre en un *runner* y puede usar una imagen Docker como entorno.

```
.gitlab-ci.yml
├── image: node:20-alpine          ← imagen por defecto
├── stages: [build, test, deploy]   ← orden de etapas
├── variables: { ENV: dev }         ← variables globales
└── <job-name>:                     ← cada job es una clave raíz
    ├── stage: build
    ├── image: node:20-alpine        ← imagen por job (sobreescribe)
    ├── script: [...]                ← comandos a ejecutar
    ├── artifacts: { paths: [dist/] }
    ├── rules: [...]                 ← cuándo se ejecuta
    └── tags: [linux]                ← selección de runner
```

A diferencia de GitHub Actions, aquí **los jobs son claves de raíz** del YAML y el orden de stages lo define `stages:`. Los jobs del mismo stage corren en paralelo; entre stages, en secuencia.

### Anatomía completa

```yaml
# .gitlab-ci.yml
image: node:20-alpine

stages:
  - build
  - test
  - deploy

variables:
  NODE_ENV: production
  # variables predefinidas: $CI_COMMIT_SHA, $CI_COMMIT_BRANCH, $CI_PIPELINE_SOURCE

default:
  cache: &npm_cache
    key:
      files: [package-lock.json]
    paths: [node_modules/]
  interruptible: true

workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    paths: [dist/]
    expire_in: 1 day

test:
  stage: test
  script:
    - npm ci
    - npm test
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy:
  stage: deploy
  environment: production
  script:
    - ./deploy.sh
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual
```

### Stages y jobs

Los `stages` definen el orden de ejecución. Un stage no empieza hasta que terminan todos los jobs del anterior (salvo `needs`).

```yaml
stages:
  - build
  - test
  - security
  - deploy
```

Cada job se asigna a un stage. Si omites `stage`, el job va a `test` por defecto.

```yaml
unit:
  stage: test
  script: npm test

lint:
  stage: test            # mismo stage que unit → corren en paralelo
  script: npm run lint

deploy:
  stage: deploy
  script: ./deploy.sh
```

> Sin `stages:` declarado, GitLab usa `pre`, `build`, `test`, `deploy`, `post` por defecto. Declararlos siempre para que el orden sea explícito.

### script, before_script, after_script

```yaml
build:
  before_script:
    - echo "Preparando entorno"
    - npm ci
  script:
    - npm run build
  after_script:
    - echo "Limpieza (corre incluso si script falló)"
```

- `before_script`: preparación (instalar deps, login a registry).
- `script`: el trabajo principal.
- `after_script`: limpieza; **corre incluso si `script` falló**, pero no puede hacer fallar el job.

### Imágenes Docker

Cada job puede correr dentro de un contenedor. `image:` define la imagen; `services:` arranca contenedores auxiliares (BD, redis…).

```yaml
test:
  image: node:20-alpine
  services:
    - name: postgres:16
      alias: db
      variables:
        POSTGRES_PASSWORD: secreto
  variables:
    DATABASE_URL: postgres://user:secreto@db:5432/app
  script:
    - npm ci
    - npm test
```

> En runners compartidos de GitLab.com los jobs corren en Docker por defecto. En self-hosted con shell executor, `image:` se ignora.

### Rules (control de ejecución)

`rules` es la forma moderna de decidir cuándo corre un job. Reemplaza al viejo `only/except`.

```yaml
deploy_prod:
  stage: deploy
  script: ./deploy.sh prod
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
    - if: $CI_PIPELINE_SOURCE == "schedule"
      when: never
    - if: $CI_COMMIT_TAG
      variables:
        RELEASE: "true"
```

| `when:` | Significado |
|---|---|
| `on_success` | (por defecto) si los jobs anteriores pasaron |
| `manual` | requiere clic humano |
| `always` | siempre |
| `never` | nunca (equivalente a excluir) |
| `delayed` | espera N segundos (`start_in: 1 hour`) |

Variables predefinidas más usadas:

| Variable | Contiene |
|---|---|
| `$CI_COMMIT_SHA` | hash del commit |
| `$CI_COMMIT_BRANCH` | nombre de la rama |
| `$CI_COMMIT_TAG` | nombre del tag (vacío si no es tag) |
| `$CI_PIPELINE_SOURCE` | qué disparó el pipeline (push, merge_request_event, schedule, web) |
| `$CI_PROJECT_DIR` | ruta del repo en el runner |
| `$CI_ENVIRONMENT_NAME` | nombre del environment del deploy |
| `$CI_REGISTRY` | URL del registry del proyecto |
| `$CI_REGISTRY_IMAGE` | ruta de la imagen del proyecto |

### Artifacts

```yaml
build:
  script: make build
  artifacts:
    paths:
      - dist/
      - reports/*.xml
    exclude:
      - dist/**/*.tmp
    expire_in: 1 week
    reports:
      junit: reports/junit.xml      # muestra resultados en el merge request
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura.xml
```

- Los artifacts del stage anterior **pasan automáticamente** al siguiente (salvo `dependencies: []`).
- `reports:` publica reportes (junit, cobertura, sast…) que GitLab muestra en la UI.
- `expire_in` controla la caducidad; `keep` los preserva indefinidamente.

### Cache

```yaml
cache:
  key:
    files:
      - package-lock.json          # invalida si cambia el lock
    prefix: $CI_COMMIT_REF_SLUG    # separa por rama
  paths:
    - node_modules/
  policy: pull-push                 # por defecto; usa pull para solo leer

install:
  script:
    - npm ci
  cache:
    <<: *npm_cache
    policy: pull
```

| `policy` | Comportamiento |
|---|---|
| `pull-push` | (default) restaura y guarda |
| `pull` | solo restaura (jobs de test que no tocan deps) |
| `push` | solo guarda (job de install que crea el cache) |

### Variables

Definidas a nivel de proyecto (Settings → CI/CD → Variables), grupo o `.gitlab-ci.yml`.

```yaml
variables:
  IMAGE_TAG: $CI_COMMIT_SHORT_SHA

deploy:
  variables:
    TARGET: staging
  script: ./deploy.sh $TARGET
```

Atributos de una variable:

- **Protected**: solo disponible en ramas/tags protegidos.
- **Masked**: oculta en los logs (debe cumplir formato: base64, JSON…).
- **Expanded**: expande otras variables (`$CI_COMMIT_REF_SLUG`).

> Secretos reales (tokens, contraseñas) van como variables **masked y protected** en la UI, no en el YAML.

### Runners y tags

```yaml
test:
  tags: [linux, docker]             # el runner debe tener todas estas etiquetas
  script: npm test

deploy_prod:
  tags: [self-hosted, prod-shell]
  script: ./deploy.sh prod
```

- Runners compartidos: disponibles en GitLab.com o en instancias self-hosted registradas como compartidos.
- Runners específicos: asociados a un proyecto. `tags` los selecciona.
- **`interruptible: true`** permite cancelar el job si llega un commit nuevo (útil en ramas de feature).

### needs: ejecución fuera de orden

`needs` permite que un job empiece sin esperar a todo el stage anterior, declarando dependencias explícitas. Activa el grafo de jobs dirigido (DAG).

```yaml
test_unit:
  stage: test
  needs: [build]
  script: npm test

test_e2e:
  stage: test
  needs: [build]
  script: npm run e2e

deploy:
  stage: deploy
  needs: [test_unit]                # no espera a test_e2e
  script: ./deploy.sh
```

Con `needs` se controla además qué artifacts recibe el job:

```yaml
test_unit:
  needs:
    - job: build
      artifacts: true
    - job: build_docs
      artifacts: false             # no recibe sus artifacts
```

### dependencies: filtrar artifacts

Sin `needs`, los jobs reciben todos los artifacts de stages anteriores. `dependencies` acota cuáles reciben:

```yaml
test_unit:
  dependencies: [build]            # solo recibe artifacts de build
  script: npm test
```

### include y reutilización

`include` trae configuración de otros archivos o proyectos. Permite plantillas compartidas.

```yaml
include:
  - local: /ci/build.yml          # archivo del mismo repo
  - project: devops/templates     # otro proyecto del mismo GitLab
    file: /lint.yml
    ref: main
  - template: Jobs/Code-Quality.gitlab-ci.yml   # plantilla oficial de GitLab
  - remote: https://ejemplo.com/ci.yml
```

*Hidden jobs* (empiezan con `.`) no se ejecutan pero sirven de plantilla con `extends` o anclas YAML:

```yaml
.template: &template
  image: node:20-alpine
  before_script: [npm ci]
  interruptible: true

unit:
  extends: .template
  script: npm test
```

### Environment y despliegue

```yaml
deploy_staging:
  stage: deploy
  environment:
    name: staging
    url: https://staging.example.com
  script: ./deploy.sh staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy_prod:
  stage: deploy
  environment:
    name: production
    url: https://app.example.com
  script: ./deploy.sh prod
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual                      # aprobación manual
  needs: [deploy_staging]
```

Los environments exponen historial de deploys y permiten *rollback* desde la UI. Puedes protegerlos con *Protected Environments* (solo ciertos usuarios pueden desplegar).

## Tablas de referencia

### Palabras clave por categoría

| Categoría | Palabras clave |
|---|---|
| Pipeline | `stages`, `workflow`, `include`, `default`, `image`, `variables` |
| Job | `stage`, `script`, `before_script`, `after_script`, `rules`, `tags`, `needs`, `dependencies` |
| Ejecución | `when`, `allow_failure`, `interruptible`, `timeout`, `retry` |
| Datos | `artifacts`, `cache`, `reports` |
| Despliegue | `environment`, `release` |

### Equivalencias con GitHub Actions

| Concepto | GitHub Actions | GitLab CI |
|---|---|---|
| Archivo | `.github/workflows/*.yml` | `.gitlab-ci.yml` |
| Trigger | `on:` | `workflow.rules:` |
| Job | `jobs.<id>` | clave raíz |
| Runner | `runs-on:` | `tags:` |
| Step | `steps:` | `script:` |
| Action reutilizable | `uses:` | `include:` / `extends:` |
| Secret | `secrets.X` | variable masked+protected |
| Environment | `environment:` | `environment:` |
| Matrix | `strategy.matrix` | `parallel:matrix:` (GitLab 17+) o `parallel:` |
| Cache | `actions/cache@v4` | `cache:` |
| Artifact | `upload/download-artifact` | `artifacts:` (automático entre stages) |
| Manual gate | `environment` con reviewers | `when: manual` |

### GitLab vs GitHub: cuándo usar cuál

| | GitHub Actions | GitLab CI |
|---|---|---|
| Integración | nativo en GitHub | nativo en GitLab |
| Runners gratis | 2000 min/mes (público ilimitado) | 400 min/mes (Free) |
| Marketplace | enorme (acciones de terceros) | plantillas oficiales + `include` |
| UI de pipelines | básica | detallada, con grupos y environments |
| Self-hosted | fácil (un binario) | con coordinator + executor |
| Apropiado si... | tu repo está en GitHub | usas GitLab como plataforma |

## Conceptos clave

- **Un solo archivo `.gitlab-ci.yml`** define todo el pipeline (más `include` para modularizar).
- **`stages` marca el orden**; los jobs del mismo stage corren en paralelo.
- **`rules` reemplaza a `only/except`**: usa `if:` con variables predefinidas para decidir qué corre.
- **Los artifacts pasan solos entre stages**; `needs`/`dependencies` afinan qué recibe cada job.
- **`cache` acelera, `artifacts` transfiere**: no los mezcles. Cache por `key.files` para invalidar bien.
- **`when: manual`** es el gate de aprobación más simple; los *Protected Environments* lo refuerzan.
- **Variables masked+protected** para secretos; nunca en el YAML.

## Errores comunes

- **Declarar `stages` en desorden**: el orden de `stages:` es el de ejecución; si lo pones alfabético, los deploys corren antes que los tests.
- **Esperar artifacts que no llegan**: si un job declara `dependencies: []`, no recibe nada de stages anteriores. Y si no existe el artifact, el job falla al referenciarlo.
- **`only/except` en pipelines nuevos**: están deprecados a favor de `rules`. Mezclarlos puede dar resultados inesperados.
- **Cache sin `key.files`**: el cache nunca se invalida y sigues con dependencias viejas.
- **Secretos en `variables:` del YAML**: quedan en el historial del repo. Usa variables masked en la UI.
- **`image:` en un runner shell**: el shell executor ignora `image:` y corre en la máquina; si esperabas contenedor, fallan las dependencias.
- **Jobs que se pisan por nombre**: dos jobs con el mismo nombre, el segundo sobrescribe al primero. Usa nombres únicos.
- **Olvidar `expire_in`**: los artifacts se acumulan y llenan el almacenamiento del proyecto.
- **`when: manual` sin `needs`**: el job manual puede bloquear el pipeline si está en un stage intermedio. Ponlo en el último stage o usa `needs`.
- **`after_script` que asume estado**: corre en un shell nuevo; las variables de `script` no persisten ahí. Recarga lo que necesites.
