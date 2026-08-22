# Automatización e integración

> Hooks, scripts, CI/CD con opencode y patrones de automatización.

## Por qué automatizar con opencode

opencode no es solo un asistente interactivo: su modo **headless** y los **hooks** permiten automatizar tareas repetitivas y meterlo en pipelines de CI/CD.

## Modo headless

El modo headless ejecuta opencode sin interfaz, ideal para scripts y automatización.

```bash
opencode run "Prompt de la tarea"
```

### Banderas útiles

| Bandera | Efecto |
|---------|--------|
| `--prompt` | El prompt a ejecutar |
| `--auto` | Aprueba acciones automáticamente |
| `--yes` | Acepta todo (alias de yolo) |
| `--model` | Usa un modelo concreto |
| `--output json` | Salida en JSON (para parsear) |
| `--session <id>` | Continúa una sesión existente |

### Ejemplo básico

```bash
opencode run "Lee los archivos de tests/ y añade tests faltantes para src/utils.js" --auto
```

## Scripts de automatización

### Script: formatear y commitear

```bash
#!/bin/bash
# auto-commit.sh - formatea y commitea cambios

opencode run "Ejecuta pnpm run format y pnpm run lint --fix. Luego crea un commit con un mensaje descriptivo de los cambios." --auto
```

### Script: generar changelog

```bash
#!/bin/bash
# generate-changelog.sh

opencode run "Analiza los commits desde el último tag con git log y genera una entrada para CHANGELOG.md siguiendo el formato Keep a Changelog." --auto
```

### Script: revisión de PR

```bash
#!/bin/bash
# review-pr.sh <pr-branch>

PR_BRANCH=$1
git checkout "$PR_BRANCH"
opencode run "Revisa los cambios de esta rama respecto a main. Identifica bugs, problemas de seguridad y mejoras de rendimiento. Genera un informe en Markdown." --output json > review.json
```

## CI/CD con opencode

### GitHub Actions

```yaml
# .github/workflows/auto-fix.yml
name: Auto-fix lint errors

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  auto-fix:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.head_ref }}

      - uses: pnpm/action-setup@v3
        with:
          version: 9

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'

      - run: pnpm install --frozen-lockfile

      - name: Install opencode
        run: npm install -g opencode-ai

      - name: Run lint and auto-fix
        env:
          OPENCODE_API_KEY: ${{ secrets.OPENCODE_API_KEY }}
        run: |
          pnpm run lint || true
          opencode run "Ejecuta pnpm run lint --fix. Si quedan errores que no se arreglan automáticamente, corrígelos editando los archivos." --auto

      - name: Commit fixes
        run: |
          git config user.name "opencode-bot"
          git config user.email "bot@opencode.ai"
          git add -A
          git diff --staged --quiet || git commit -m "fix: auto-fix lint errors"
          git push
```

### Casos de uso en CI

| Caso | Descripción |
|------|-------------|
| Auto-fix lint | Corregir errores de lint automáticamente en cada PR |
| Generar tests | Crear tests para código nuevo |
| Actualizar docs | Regenerar README o docs tras cambios |
| Review de código | Análisis automático de PRs |
| Migraciones | Refactors mecánicos (rename, API change) |
| Dependabot follow-up | Actualizar código tras bump de dependencias |

### GitLab CI

```yaml
# .gitlab-ci.yml
opencode-review:
  stage: test
  image: node:20
  variables:
    OPENCODE_API_KEY: $OPENCODE_API_KEY
  before_script:
    - npm install -g opencode-ai
    - pnpm install --frozen-lockfile
  script:
    - opencode run "Revisa los cambios del MR y genera un informe de calidad" --auto
  only:
    - merge_requests
```

## Hooks para automatización

Los hooks ejecutan scripts en eventos del ciclo de vida de opencode.

### preToolUse: formatear antes de leer

```json
{
  "hooks": {
    "preToolUse": [
      "pnpm run format"
    ]
  }
}
```

Cada vez que el agente va a usar una herramienta, se formatea el código para que lea una versión limpia.

### postToolUse: validar después de editar

```json
{
  "hooks": {
    "postToolUse": [
      "pnpm run lint --fix",
      "pnpm run typecheck"
    ]
  }
}
```

Tras cada edición, se ejecutan lint y typecheck. Si fallan, el agente lo ve en la salida y puede corregir.

### onSessionStart: preparar entorno

```json
{
  "hooks": {
    "onSessionStart": [
      "echo '=== Estado del repo ==='",
      "git status --short",
      "echo '=== Tests ==='",
      "pnpm test --passWithNoTests 2>&1 | tail -5"
    ]
  }
}
```

Al iniciar sesión, el agente ve el estado del repo y de los tests, dándole contexto inicial.

### onStop: notificar

```json
{
  "hooks": {
    "onStop": [
      "echo '\\a'"
    ]
  }
}
```

Hace un sonido cuando el agente termina (útil para saber que acaba).

## Hooks avanzados con scripts

Los hooks pueden ser scripts complejos. Crea un script en `.opencode/hooks/`:

```bash
#!/bin/bash
# .opencode/hooks/post-edit.sh
pnpm run lint --fix 2>&1
if [ $? -ne 0 ]; then
  echo "Lint errors detectados"
  exit 1
fi
pnpm run typecheck 2>&1
```

```json
{
  "hooks": {
    "postToolUse": [".opencode/hooks/post-edit.sh"]
  }
}
```

### Hooks condicionales

Los hooks reciben contexto sobre el evento (qué archivo se editó, qué herramienta se usó). Un script puede decidir si actuar:

```bash
#!/bin/bash
# .opencode/hooks/post-edit.sh
# Solo formatear archivos JS/TS
FILE="$1"
case "$FILE" in
  *.js|*.ts|*.jsx|*.tsx)
    pnpm prettier --write "$FILE"
    ;;
esac
```

## Integración con git

### Commit automático

```bash
opencode run "Commitea los cambios actuales con un mensaje que siga conventional commits, basándote en git diff" --auto
```

### Crear PR

```json
{
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "${GITHUB_TOKEN}" }
    }
  }
}
```

```bash
opencode run "Crea una rama llamada feature/payment, commitea los cambios y abre un PR contra main con el MCP de GitHub" --auto
```

## Plantillas de prompts

Para tareas repetitivas, guarda plantillas de prompts:

```markdown
<!-- .opencode/prompts/add-test.md -->
Añade tests para el archivo `${FILE}`:
- Usa el framework de testing del proyecto (revisa package.json).
- Cubre casos normales y casos borde (vacío, null, errores).
- Sigue el patrón AAA (Arrange-Act-Assert).
- Usa nombres descriptivos: should <comportamiento> when <condición>.
```

```bash
opencode run "$(cat .opencode/prompts/add-test.md)" --auto
```

## Programación de tareas

Combina opencode con cron para tareas periódicas:

```bash
# crontab -e
0 2 * * 1 cd /home/user/mi-proyecto && opencode run "Actualiza las dependencias con pnpm update y arregla lo que se rompa" --auto >> /var/log/opencode-cron.log 2>&1
```

Esto ejecuta cada lunes a las 2am una actualización de dependencias automatizada.

## Observabilidad

Para auditar lo que hace opencode en CI:

- Usa `--output json` para obtener resultados estructurados.
- Guarda los logs.
- Revisa los diffs aplicados.

```bash
opencode run "..." --auto --output json > result.json
jq '.actions[] | {type, file, status}' result.json
```

## Buenas prácticas

1. **Usa `--auto` con cuidado:** solo en tareas bien definidas y revisadas.
2. **Limita el scope:** el agente solo debe ver y tocar lo necesario.
3. **Comitea los prompts y hooks** para que el equipo use los mismos.
4. **Audita los logs** en CI para detectar comportamientos inesperados.
5. **Usa secrets del CI** para tokens, nunca en el código.
6. **Empieza simple:** automatiza una tarea pequeña antes de procesos complejos.

---

> Anterior: [Configuración y personalización](03-configuracion-y-personalizacion.md) · Siguiente: [Producción y buenas prácticas](05-produccion-y-buenas-practicas.md)
