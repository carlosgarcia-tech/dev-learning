# Ejercicio 15 — Deploy con script

- **Nivel:** 3/5
- **Tema:** `environment`, scripts de deploy, `secrets`, gate manual
- **Tiempo estimado:** 25 min

## Enunciado

Crea un workflow en `.github/workflows/deploy.yml` y un script `scripts/deploy.sh` que:

1. El workflow se dispara en `push` a `main`.
2. Tiene un job `deploy` en `ubuntu-latest` con `environment: staging`.
3. Usa `actions/checkout@v4`.
4. Ejecuta `bash scripts/deploy.sh` pasando el secret `DEPLOY_KEY` por `env:`.
5. El script `scripts/deploy.sh` lee `$DEPLOY_KEY` del entorno y simula un despliegue (imprime "Desplegando a staging con key [REDACTED]").

## Requisitos

- [ ] El archivo existe en `.github/workflows/deploy.yml`.
- [ ] El job `deploy` tiene `environment: staging`.
- [ ] El workflow ejecuta `bash scripts/deploy.sh`.
- [ ] El secret `DEPLOY_KEY` se pasa vía `env:`.
- [ ] Existe `scripts/deploy.sh` con shebang y `set -euo pipefail`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `environment: staging` activa los secrets y reglas del entorno "staging".
- Los scripts deben llevar `#!/usr/bin/env bash` y `set -euo pipefail` al inicio.
- Los secrets se inyectan con `env:`, nunca como argumentos de `run:`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
# scripts/deploy.sh
set -euo pipefail

echo "Desplegando a staging con key [REDACTED]"
echo "Deploy OK a $DEPLOY_KEY"  # en real, no se imprime
echo "Staging listo"
```

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - name: Desplegar a staging
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
        run: bash scripts/deploy.sh
```

</details>
