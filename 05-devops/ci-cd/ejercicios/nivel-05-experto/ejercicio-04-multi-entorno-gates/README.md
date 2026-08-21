# Ejercicio 28 — Pipeline multi-entorno con gates

- **Nivel:** 5/5
- **Tema:** dev → staging → prod, `environment`, `needs`, approval gates
- **Tiempo estimado:** 40 min

## Enunciado

Crea un workflow en `.github/workflows/multi-entorno.yml` que despliegue a tres entornos con gates:

1. `deploy_dev`: se ejecuta siempre (tras CI), `environment: dev`, ejecuta `echo "Deploy a dev"`.
2. `deploy_staging`: depende de `deploy_dev` con `needs`, `environment: staging`, ejecuta `echo "Deploy a staging"`.
3. `deploy_prod`: depende de `deploy_staging` con `needs`, `environment: production`, ejecuta `echo "Deploy a prod"`.
4. Crea `scripts/deploy.sh` que recibe el entorno como argumento e imprime "Desplegando a <entorno>".

> El entorno `production` debe tener *required reviewers* configurados en GitHub. El job se pausa hasta la aprobación.

## Requisitos

- [ ] El archivo existe en `.github/workflows/multi-entorno.yml`.
- [ ] Hay tres jobs: `deploy_dev`, `deploy_staging`, `deploy_prod`.
- [ ] `deploy_staging` tiene `needs: deploy_dev`.
- [ ] `deploy_prod` tiene `needs: deploy_staging` y `environment: production`.
- [ ] Cada job tiene su `environment` correspondiente.
- [ ] Existe `scripts/deploy.sh` con shebang y `set -euo pipefail`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `environment: <name>` activa secrets y reglas de protección de cada entorno.
- Para que el gate funcione, configura *Required reviewers* en Settings → Environments → production.
- `needs` encadena los jobs: dev → staging → prod en secuencia.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
# scripts/deploy.sh
set -euo pipefail
ENTORNO="${1:?Uso: deploy.sh <entorno>}"
echo "Desplegando a $ENTORNO"
echo "Deploy $ENTORNO OK"
```

```yaml
# .github/workflows/multi-entorno.yml
name: Multi-Entorno
on:
  push:
    branches: [main]
jobs:
  deploy_dev:
    runs-on: ubuntu-latest
    environment: dev
    steps:
      - uses: actions/checkout@v4
      - run: bash scripts/deploy.sh dev
  deploy_staging:
    needs: deploy_dev
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - run: bash scripts/deploy.sh staging
  deploy_prod:
    needs: deploy_staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - run: bash scripts/deploy.sh prod
```

</details>
