# 04 — Pipelines avanzados

## Objetivos

- [ ] Diseñar pipelines dinámicos que generen jobs en función de variables o archivos.
- [ ] Dominar la *matrix* con `include`/`exclude` y matrices dinámicas.
- [ ] Aplicar paralelismo y `fail-fast`/`max-parallel` para optimizar tiempo y coste.
- [ ] Escribir jobs condicionales con `if` y expresiones complejas.
- [ ] Construir *reusable workflows* (`workflow_call`) y plantillas reutilizables.
- [ ] Modelar *monorepos* con path filters y jobs condicionales por paquete.
- [ ] Gestionar dependencias entre jobs con `needs` y grafo dirigido (DAG).
- [ ] Implementar *approval gates* con environments y revisiones.
- [ ] Pasar datos entre jobs con `outputs` y `fromJSON`.
- [ ] Medir y optimizar el tiempo de pipeline (cache, paralelismo, cancelación).

## Apuntes

### Pipelines dinámicos

Un pipeline *dinámico* genera jobs en tiempo de ejecución a partir de variables, archivos de configuración o salidas de pasos previos.

#### GitHub Actions: matrix dinámica desde JSON

```yaml
name: Matrix dinámica
on: push
jobs:
  generar:
    runs-on: ubuntu-latest
    outputs:
      matriz: ${{ steps.gen.outputs.matriz }}
    steps:
      - uses: actions/checkout@v4
      - id: gen
        run: |
          # Lee un archivo de config y produce un JSON de matriz
          MODULOS=$(jq -c '[.modulos[] | {nombre, version}]' config.json)
          echo "matriz=$MODULOS" >> "$GITHUB_OUTPUT"

  ejecutar:
    needs: generar
    runs-on: ubuntu-latest
    strategy:
      matrix:
        value: ${{ fromJSON(needs.generar.outputs.matriz) }}
    steps:
      - run: echo "Construyendo ${{ matrix.value.nombre }} @ ${{ matrix.value.version }}"
```

#### GitLab CI: pipeline dinámico con `parent-child`

GitLab puede generar pipelines hijos con `trigger` y `include`, o generar configuración con un script que escribe un YAML y se importa con `include:local`.

```yaml
generar_pipeline:
  stage: build
  script:
    - python3 generar_jobs.py > generated.yml
  artifacts:
    paths: [generated.yml]

ejecutar_dinamico:
  stage: test
  needs: [generar_pipeline]
  trigger:
    include:
      - artifact: generated.yml
        job: generar_pipeline
    strategy: depend
```

También existe `dynamic_child_pipeline` (GitLab 17+) para generar pipelines hijos sin archivo intermedio.

### Matrices avanzadas

#### GitHub Actions: include / exclude

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      max-parallel: 4            # limita concurrentes
      matrix:
        os: [ubuntu-latest, windows-latest]
        node: [18, 20, 22]
        exclude:
          - os: windows-latest
            node: 18
        include:
          - os: macos-latest
            node: 20
            extra: cobertura
    steps:
      - run: echo "$OSTYPE node${{ matrix.node }}"
```

- `include` añade combinaciones nuevas o campos extra a combinaciones existentes.
- `exclude` quita combinaciones concretas.
- `max-parallel` limita cuántos jobs corren a la vez (ahorra runners).

#### GitLab CI: parallel y matrix

```yaml
test:
  stage: test
  parallel: 5                    # 5 jobs idénticos, $CI_NODE_INDEX/$CI_NODE_TOTAL

test_matrix:
  stage: test
  parallel:
    matrix:
      - OS: [alpine, debian]
        NODE: [18, 20]
  script:
    - echo "$OS node$NODE"
```

### Paralelismo y control de fallos

| Estrategia | GitHub Actions | GitLab CI | Efecto |
|---|---|---|---|
| No cancelar en fallo | `fail-fast: false` | (por defecto) | ver todos los fallos |
| Limitar concurrentes | `max-parallel: N` | — | no saturar runners |
| Job opcional | `continue-on-error: true` | `allow_failure: true` | no rompe el pipeline |
| Reintentar | (con action) | `retry: 2` | reintenta el job |
| Cancelar anteriores | `concurrency` | `interruptible: true` | evita colas |

```yaml
# GitHub Actions: job experimental que no bloquea
experimental:
  continue-on-error: true
  runs-on: ubuntu-latest
  steps:
    - run: npm run test:e2e
```

```yaml
# GitLab CI: job que puede fallar
lint_estilo:
  allow_failure: true
  script: npm run lint:estilo
```

### Jobs condicionales

GitHub Actions con `if` y expresiones:

```yaml
deploy:
  if: |
    github.ref == 'refs/heads/main' &&
    github.event_name == 'push' &&
    !contains(github.event.head_commit.message, '[skip-deploy]')
  runs-on: ubuntu-latest
  steps: [...]

deploy_tag:
  if: startsWith(github.ref, 'refs/tags/v')
  runs-on: ubuntu-latest
  steps: [...]
```

GitLab CI con `rules`:

```yaml
deploy:
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      changes: [src/**, package.json]
    - if: $CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/
```

### Reusable workflows (GitHub Actions)

Un *reusable workflow* se define con `on: workflow_call` y se invoca con `uses:` desde otro workflow. Permite compartir lógica entre repos sin duplicar.

```yaml
# .github/workflows/build-node.yml (reusable)
on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string
    secrets:
      REGISTRY_TOKEN:
        required: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
          cache: npm
      - run: npm ci && npm run build
```

```yaml
# .github/workflows/ci.yml (caller)
name: CI
on: push
jobs:
  build:
    uses: ./.github/workflows/build-node.yml
    with:
      node-version: "20"
    secrets:
      REGISTRY_TOKEN: ${{ secrets.REGISTRY_TOKEN }}
```

> Los reusable workflows pueden vivir en el mismo repo (`uses: ./.github/workflows/x.yml`) o en otro (`uses: org/repo/.github/workflows/x.yml@v1`).

### Plantillas (GitLab CI)

GitLab reutiliza con `include` y *hidden jobs* con `extends`:

```yaml
# /ci/templates/node-test.yml
.node-test:
  image: node:20-alpine
  before_script: [npm ci]
  interruptible: true
  script: npm test
```

```yaml
# .gitlab-ci.yml
include:
  - local: /ci/templates/node-test.yml

unit:
  extends: .node-test
  script: npm run test:unit

e2e:
  extends: .node-test
  script: npm run test:e2e
  allow_failure: true
```

### Monorepo pipelines

En un monorepo, varios paquetes conviven. No quieres correr el pipeline completo cuando solo cambió un paquete.

#### GitHub Actions: path filters

```yaml
on:
  push:
    paths:
      - "packages/**"
      - ".github/workflows/**"

jobs:
  cambios:
    runs-on: ubuntu-latest
    outputs:
      frontend: ${{ steps.f.outputs.frontend }}
      backend: ${{ steps.f.outputs.backend }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: f
        with:
          filters: |
            frontend:
              - 'packages/frontend/**'
            backend:
              - 'packages/backend/**'

  test-frontend:
    needs: cambios
    if: needs.cambios.outputs.frontend == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Test frontend"

  test-backend:
    needs: cambios
    if: needs.cambios.outputs.backend == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Test backend"
```

#### GitLab CI: changes por job

```yaml
test_frontend:
  rules:
    - changes: [packages/frontend/**]
  script: cd packages/frontend && npm test

test_backend:
  rules:
    - changes: [packages/backend/**]
  script: cd packages/backend && npm test
```

### Dependencias entre jobs (DAG)

Con `needs` construyes un grafo dirigido: un job empieza en cuanto sus dependencias terminan, sin esperar a todo el stage.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps: [...]

  lint:
    needs: build
    runs-on: ubuntu-latest
    steps: [...]

  unit:
    needs: build
    runs-on: ubuntu-latest
    steps: [...]

  e2e:
    needs: build
    runs-on: ubuntu-latest
    steps: [...]

  deploy:
    needs: [lint, unit, e2e]      # solo cuando los tres pasan
    runs-on: ubuntu-latest
    steps: [...]
```

```
        build
       /  |  \
    lint unit e2e
       \  |  /
       deploy
```

GitLab CI equivalente con `needs`:

```yaml
unit:
  needs: [build]

e2e:
  needs: [build]

deploy:
  needs: [unit, e2e]
```

### Approval gates

#### GitHub Actions: environments con reviewers

```yaml
deploy_prod:
  needs: [build, test]
  runs-on: ubuntu-latest
  environment:
    name: production
    url: https://app.example.com
  steps:
    - run: ./deploy.sh prod
```

Configura en GitHub: Settings → Environments → *production* → Required reviewers (añade usuarios/teams). El job se pausa hasta la aprobación.

#### GitLab CI: when manual + protected environment

```yaml
deploy_prod:
  stage: deploy
  environment:
    name: production
  script: ./deploy.sh prod
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual                      # botón de aprobación
```

Configura Protected Environments (Settings → Repository → Protected Environments) para restringir quién puede ejecutar el job manual.

### Pasar datos entre jobs

```yaml
jobs:
  meta:
    runs-on: ubuntu-latest
    outputs:
      tag: ${{ steps.t.outputs.tag }}
      matriz: ${{ steps.m.outputs.matriz }}
    steps:
      - id: t
        run: echo "tag=$(date +%Y%m%d)-${GITHUB_SHA::7}" >> "$GITHUB_OUTPUT"
      - id: m
        run: echo "matriz=[\"a\",\"b\",\"c\"]" >> "$GITHUB_OUTPUT"

  usar:
    needs: meta
    runs-on: ubuntu-latest
    strategy:
      matrix:
        item: ${{ fromJSON(needs.meta.outputs.matriz) }}
    steps:
      - run: echo "${{ needs.meta.outputs.tag }} ${{ matrix.item }}"
```

### Optimización de tiempo

| Técnica | Ahorro | Cómo |
|---|---|---|
| Cache de dependencias | 50-80% | `cache: npm` / `cache.key.files` |
| Paralelismo entre jobs | lineal | dividir en jobs + `needs` |
| Path filters (monorepo) | variable | solo correr lo que cambió |
| Cancelar runs viejos | colas | `concurrency: cancel-in-progress` |
| `max-parallel` | coste runners | limitar matrix concurrente |
| Self-hosted runners | dinero | si tienes infra ociosa |

## Tablas de referencia

### Comparativa de reutilización

| Necesito... | GitHub Actions | GitLab CI |
|---|---|---|
| Compartir pipeline entre repos | reusable workflow (`workflow_call`) | `include` desde otro proyecto |
| Parametrizar | `inputs` / `secrets` en `workflow_call` | variables + `include` con `inputs` |
| Plantilla dentro del repo | composite action o reusable | hidden job + `extends` |
| Versionar plantillas | anclar a `@vN` o SHA | `ref:` en `include` |

### Patrones de grafo

| Patrón | Forma | Uso |
|---|---|---|
| Lineal | A → B → C | simple, secuencial |
| Abanico | A → (B, C, D) → E | paralelizar tests |
| Diamante | A → (B, C) → D | build + 2 tests + deploy |
| DAG libre | `needs` arbitrario | optimizar tiempo crítico |

## Conceptos clave

- **Dinamismo = generar jobs según datos**: matrices desde JSON (GitHub) o child pipelines (GitLab).
- **`include`/`exclude` filtran la matrix** sin reescribirla; `max-parallel` limita coste.
- **Reusable workflows** son la forma idiomática de GitHub Actions para compartir CI; `include`+`extends` lo es en GitLab.
- **Monorepo = path filters**: solo corre lo que cambió. Ahorra runners y tiempo.
- **`needs` construye el DAG**: el job empieza cuando sus dependencias terminan, no cuando termina el stage.
- **Approval gates**: environments con reviewers (GitHub) o `when: manual` + protected environments (GitLab).
- **Optimiza midiendo**: cache, paralelismo y path filters son las palancas más rentables.

## Errores comunes

- **Matrix enorme sin `max-parallel`**: genera 30 jobs, satura los runners y el pipeline tarda más por colas.
- **`fail-fast: true` (por defecto) en matrix de test**: un fallo cancela el resto y oculta fallos relacionados.
- **Reusable workflow sin `secrets` pasados**: el workflow llamado no hereda los secrets del caller; hay que pasarlos con `secrets:`.
- **Path filter que no incluye `.github/workflows/`**: si cambias el workflow pero no el código, el pipeline no se dispara.
- **`needs` que crea dependencias circulares**: el validador falla; revisa el grafo.
- **`if` que evalúa mal el contexto**: `github.ref` incluye `refs/heads/`; comparar con `main` solo es falso.
- **Aprobación que nadie supervisa**: si los reviewers no están configurados, el gate no existe. Verifica en Settings.
- **Pasar outputs complejos sin `fromJSON`**: un string `"['a','b']"` no se itera hasta parsearlo.
- **`continue-on-error` en jobs críticos**: lo pones para "no romper" y acabas desplegando con tests rotos.
- **Olvidar cancelar runs viejos**: cada push a una rama de feature lanza un run que se acumula. Usa `concurrency`.
