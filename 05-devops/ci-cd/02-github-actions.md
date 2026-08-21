# 02 — GitHub Actions

## Objetivos

- [ ] Entender el modelo de GitHub Actions: workflows, events, jobs, steps y actions.
- [ ] Saber dónde viven los workflows (`.github/workflows/*.yml`) y cómo se nombran.
- [ ] Configurar triggers (`on:`) para push, pull request, schedule, manual y de tags.
- [ ] Escribir jobs con `runs-on`, `steps`, `uses`, `with`, `run` y `env`.
- [ ] Usar actions del GitHub Marketplace (`checkout`, `setup-node`, `cache`, `upload-artifact`).
- [ ] Gestionar *secrets* y *variables* a nivel de repo, environment y organización.
- [ ] Distinguir *environments* (dev, staging, prod) y sus reglas de protección y aprobación.
- [ ] Construir una *matrix* para ejecutar el mismo job en múltiples versiones/OS.
- [ ] Configurar cache y artifacts para acelerar y compartir resultados.
- [ ] Usar `needs`, `if`, `outputs` y `secrets` para encadenar y condicionar jobs.
- [ ] Diagnosticar logs, reintentos y permisos (`permissions`, `GITHUB_TOKEN`).

## Apuntes

### El modelo de GitHub Actions

GitHub Actions ejecuta *workflows* definidos en YAML dentro de `.github/workflows/`. Un workflow se dispara por un *event* (`on:`) y contiene *jobs* que corren en *runners*. Cada job tiene *steps*, que son comandos (`run:`) o llamadas a *actions* (`uses:`).

```
workflow  (.github/workflows/ci.yml)
├── name: CI
├── on: push                       ← event (trigger)
└── jobs:
    └── build:                      ← job
        ├── runs-on: ubuntu-latest   ← runner
        ├── env: NODE_ENV=test      ← variables de entorno
        └── steps:                   ← pasos
            ├── - uses: actions/checkout@v4   ← action (reutilizable)
            ├── - run: npm ci                  ← comando de shell
            └── - uses: actions/upload-artifact@v4
                with: { name: dist, path: dist/ }
```

### Anatomía de un workflow

```yaml
name: CI/CD

on:
  push:
    branches: [main, "feature/**"]   # filtros de rama (comillas si hay *)
  pull_request:
  schedule:
    - cron: "30 5 * * 1"             # cada lunes 05:30 UTC
  workflow_dispatch:                 # disparo manual
    inputs:
      debug:
        description: "Modo debug"
        type: boolean
        default: false

# Permisos del GITHUB_TOKEN (principio de mínimo privilegio)
permissions:
  contents: read
  packages: write

env:
  GLOBAL: valor                      # variables a nivel de workflow

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      JOB_ENV: valor                 # variables a nivel de job
    steps:
      - uses: actions/checkout@v4
      - run: echo "Hola ${{ github.actor }}"
```

### Events (triggers)

| Event | Dispara cuando... | Ejemplo |
|---|---|---|
| `push` | se sube un commit | `on: push` o filtrando ramas/tags |
| `pull_request` | se abre/edita/mergea un PR | `on: [opened, synchronize]` |
| `schedule` | cron programado | `cron: "0 3 * * *"` |
| `workflow_dispatch` | botón manual | con `inputs` |
| `workflow_call` | lo llama otro workflow (reusable) | base de los *reusable workflows* |
| `release` | se publica un release/tag | `on: release: types: [published]` |
| `repository_dispatch` | API externa | integración con otros sistemas |

Filtros:

```yaml
on:
  push:
    branches: [main, develop]
    paths:                          # solo si cambian estos archivos
      - "src/**"
      - "package.json"
    tags: ["v*"]                    # solo tags que empiecen por v
  pull_request:
    types: [opened, reopened, synchronize]
```

> `paths` filtra por rutas; `paths-ignore` excluye. Si combinas `paths` y `paths-ignore`, `paths` gana.

### Jobs

Un job es una unidad que corre en un runner. Por defecto los jobs corren **en paralelo**; con `needs` se encadenan en secuencia.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps: [...]
  test:
    needs: build                    # test espera a que build termine
    runs-on: ubuntu-latest
    steps: [...]
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'   # solo en main
    runs-on: ubuntu-latest
    environment: production         # activa reglas de entorno
    steps: [...]
```

Atributos clave de un job:

| Atributo | Para qué |
|---|---|
| `runs-on` | máquina/etiqueta del runner |
| `needs` | dependencias (orden secuencial) |
| `if` | condición para ejecutar o no |
| `environment` | entorno lógico (secrets y reglas) |
| `env` | variables de entorno del job |
| `timeout-minutes` | aborta si excede el tiempo |
| `continue-on-error` | el job falla pero no rompe el workflow |
| `strategy` | matrix y paralelismo |
| `concurrency` | cancela runs anteriores de la misma rama |
| `outputs` | valores que otros jobs pueden leer |

### Steps

Dentro de un job, los `steps` se ejecutan en orden. Cada step es `uses:` (action) o `run:` (comando).

```yaml
steps:
  - name: Descargar código           # name aparece en los logs
    uses: actions/checkout@v4
    with:
      fetch-depth: 0                 # historial completo

  - name: Instalar Node
    uses: actions/setup-node@v4
    with:
      node-version: 20
      cache: npm                    # cache automático

  - name: Instalar dependencias
    run: npm ci

  - name: Tests
    run: npm test
    env:
      CI: true                      # los runners exponen env por step
```

### Actions

Una *action* es una unidad reutilizable publicada en el [GitHub Marketplace](https://github.com/marketplace?type=actions). Se llama con `uses:` y se configura con `with:`.

| Action | Para qué |
|---|---|
| `actions/checkout@v4` | clona el repo en el runner |
| `actions/setup-node@v4` | instala Node y cachea npm |
| `actions/cache@v4` | cache genérico por clave |
| `actions/upload-artifact@v4` | sube archivos como artifact |
| `actions/download-artifact@v4` | baja artifacts de otros jobs |
| `actions/github-script@v7` | ejecuta JS con el SDK de GitHub |
| `docker/build-push-action@v6` | construye y publica imágenes |

```yaml
- uses: actions/checkout@v4
  with:
    submodules: true
- uses: actions/setup-python@v5
  with:
    python-version: "3.12"
    cache: pip
- run: pip install -r requirements.txt
```

> `@v4` ancla a una versión mayor. Anclar a un commit SHA (`@<sha>`) es más seguro para CI de producción (evita supply-chain). Nunca uses `@main`/`@master` sin anclar.

### Runners

```yaml
runs-on: ubuntu-latest              # runner gestionado Linux
runs-on: windows-latest             # Windows
runs-on: macos-latest               # macOS
runs-on: [self-hosted, linux, x64]  # self-hosted con etiquetas
```

Los runners gestionados tienen software preinstalado (Docker, Node, Python…). Los *self-hosted* los administras tú: más control pero tú los mantienes y parcheas.

### Secrets y variables

Los *secrets* son valores cifrados que el workflow usa pero no se ven en los logs. Las *variables* son valores no secretos reutilizables.

| Nivel | Dónde se definen |
|---|---|
| Repo | Settings → Secrets and variables → Actions |
| Environment | Settings → Environments → `<env>` → secrets |
| Organization | Settings → Secrets → Actions (compartidos entre repos) |

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: deploy.sh
        env:
          API_KEY: ${{ secrets.API_KEY }}     # del environment o del repo
          REGISTRY: ${{ vars.REGISTRY }}       # variable no secreta
```

Reglas:

- **Los secrets nunca se imprimen** en los logs (GitHub los enmascara).
- **No se pasan directamente como argumento** de un comando (quedarían en la línea de proceso); van por `env:`.
- Los secrets del *environment* solo están disponibles cuando el job declara `environment: <name>`.
- Las variables `vars.*` son de texto plano (URLs, imágenes base…).

### Environments

Un *environment* es un entorno lógico (dev, staging, production) con sus propios secrets y reglas de protección. Activa *approval gates* y restricciones de rama.

```yaml
jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com   # aparece en el check
    steps: [...]

  deploy-prod:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production              # requiere aprobación configurada en GitHub
    steps: [...]
```

Reglas configurables por environment:

- **Required reviewers**: alguien debe aprobar antes de que el job corra.
- **Deployment branches**: qué ramas pueden desplegar a ese entorno.
- **Wait timer**: espera N minutos antes de ejecutar (enfriamiento).
- **Environment secrets**: secrets exclusivos del entorno.

### Matrix

La *matrix* ejecuta el mismo job con varias combinaciones de variables. Útil para probar múltiples versiones de lenguaje, SO o arquitecturas.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false                  # no cancele los demás si uno falla
      matrix:
        node: [18, 20, 22]
        os: [ubuntu-latest, macos-latest]
        exclude:
          - os: macos-latest
            node: 18                    # excluye esa combinación
        include:
          - os: windows-latest
            node: 20
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: npm ci && npm test
```

Cada combinación genera un job `test (os, node)`. Con `matrix.os × matrix.node` se generan N jobs en paralelo.

### Cache

El cache reutiliza dependencias entre runs. La clave debe invalidarse cuando cambian los ficheros de dependencias.

```yaml
- uses: actions/cache@v4
  with:
    path: |
      ~/.npm
      node_modules
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-
```

Atajos específicos que ya cachean:

```yaml
- uses: actions/setup-node@v4
  with: { node-version: 20, cache: npm }
- uses: actions/setup-python@v5
  with: { python-version: "3.12", cache: pip }
- uses: actions/setup-java@v4
  with: { distribution: temurin, java-version: 21, cache: maven }
```

> Si la `key` coincide 100% con un cache anterior, GitHub lo restaura; si no, prueba `restore-keys` (parcial) y al final guarda un cache nuevo con la `key` exacta.

### Artifacts

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: make build
      - uses: actions/upload-artifact@v4
        with:
          name: binario
          path: dist/
          retention-days: 7
          if-no-files-found: error       # falla si no hay nada que subir

  package:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: binario
          path: dist/
      - run: tar czf app.tar.gz dist/
```

### Encadenar jobs: needs, if, outputs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.meta.outputs.version }}
    steps:
      - id: meta
        run: echo "version=$(cat VERSION)" >> "$GITHUB_OUTPUT"

  publish:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Publicando ${{ needs.build.outputs.version }}"

  notify:
    needs: [build, publish]
    if: always()                        # corre incluso si algo falló
    runs-on: ubuntu-latest
    steps:
      - run: echo "Resultado: ${{ job.status }}"
```

Expresiones útiles en `if`:

| Expresión | Significado |
|---|---|
| `always()` | siempre (incluso si previos fallaron) |
| `success()` | (por defecto) todos los needs terminaron bien |
| `failure()` | algún need falló |
| `cancelled()` | el workflow fue cancelado |
| `github.ref == 'refs/heads/main'` | solo en la rama main |
| `github.event_name == 'pull_request'` | solo en PR |

### Concurrency

Evita que varios runs de la misma rama corran a la vez, cancelando el anterior:

```yaml
concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true
```

### Permisos del GITHUB_TOKEN

Cada workflow recibe un `GITHUB_TOKEN` con permisos. Define el mínimo necesario:

```yaml
permissions:
  contents: read          # leer repo
  packages: write         # publicar en GHCR
  pull-requests: write    # comentar en PRs
```

## Tablas de referencia

### Contextos disponibles

| Contexto | Contiene |
|---|---|
| `github` | info del evento, repo, actor, ref, sha |
| `env` | variables de entorno del workflow |
| `vars` | variables (no secretas) del repo/org |
| `secrets` | secrets del repo/org/environment |
| `matrix` | valores de la matrix actual |
| `needs` | outputs de jobs de los que depende |
| `steps` | outputs de steps del mismo job |
| `runner` | info del runner (OS, arch) |
| `job` | estado del job (`job.status`) |

### Sintaxis de expresiones

| Símbolo | Uso |
|---|---|
| `${{ expr }}` | evalúa una expresión |
| `&&` `\|\|` `!` | operadores lógicos |
| `==` `!=` `<` `>` | comparación |
| `contains(a, b)` | true si `a` contiene `b` |
| `startsWith(a, b)` | true si `a` empieza por `b` |
| `join(arr, sep)` | une array con separador |
| `toJSON(x)` | serializa a JSON |
| `fromJSON(s)` | parsea JSON |

### Límites práerticos

| Límite | Valor aprox. |
|---|---|
| Jobs por workflow | 256 |
| Steps por job | 1000 |
| Matriz (jobs generados) | 256 |
| Duración de un job | 6 h (gestionados) |
| Retención de artifacts | configurable, 90 días por defecto |

## Conceptos clave

- **Workflow = archivo YAML en `.github/workflows/`**. Un repo puede tener muchos.
- **`uses:` llama a una action; `run:` ejecuta un comando**. Las actions encapsulan lógica reutilizable del Marketplace.
- **Los jobs corren en paralelo por defecto**: usa `needs` para secuenciar.
- **`environment:` activa secrets y reglas de protección** (approval gates, ramas permitidas).
- **Matrix = multiplicador de jobs**. Úsala para versiones/OS, pero ojo con los minutos de runner que consume.
- **Cache por `hashFiles()`**: invalida cuando cambian las dependencias. Sin `key` dinámica, el cache se pudre.
- **Principio de mínimo privilegio**: declara `permissions` explícitamente y usa secrets de environment, no de repo, para producción.

## Errores comunes

- **Olvidar `actions/checkout@v4`**: el runner empieza con el workspace vacío; cualquier comando que toca el repo falla.
- **Anclar a `@main` o `@master`**: si la action cambia, tu workflow se rompe sin tocarlo. Ancla a `@vN` o a un SHA.
- **Usar `@v1` obsoletas**: muchas actions v1 están deprecated (p. ej. `actions/checkout@v1`). Usa las `@v4`.
- **Pasar secrets como argumento de `run:`**: `run: deploy ${{ secrets.TOKEN }}` lo deja visible en los logs de proceso. Usa `env:`.
- **No declarar `environment` en jobs de producción**: los secrets de environment no se inyectan y los approval gates no saltan.
- **Matrix sin `fail-fast: false`**: un fallo cancela el resto y no ves el panorama completo.
- **Cache con `key` estática**: nunca se invalida y sigues usando dependencias viejas. Incluye `hashFiles(...)`.
- **`if: github.ref == 'main'`**: la ref incluye el prefijo. Lo correcto es `refs/heads/main`.
- **No limitar `permissions`**: el `GITHUB_TOKEN` con `write` a todo es un riesgo si un PR malicioso lo usa.
- **Olvidar `concurrency` en ramas de feature**: se acumulan runs paralelos y se gastan minutos.
- **`outputs` mal referenciados**: `${{ steps.id.outputs.x }}` dentro del job; `${{ needs.job.outputs.x }}` desde otro job.
