# Ejercicio 11 — Secrets

- **Nivel:** 2/5
- **Tema:** `secrets`, `env`, inyección segura de credenciales
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/secrets.yml` que:

1. Se dispare en `push`.
2. Tenga un job `deploy` en `ubuntu-latest`.
3. Use `actions/checkout@v4`.
4. Pase un secret `${{ secrets.API_TOKEN }}` al entorno del step con `env: API_TOKEN: ${{ secrets.API_TOKEN }}`.
5. Ejecuta un script `./deploy.sh` que usa `$API_TOKEN` (no lo imprime en pantalla).

> Los secrets nunca se pasan como argumento directo de `run:` (quedarían visibles). Se inyectan con `env:`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/secrets.yml`.
- [ ] El job `deploy` referencia `secrets.API_TOKEN`.
- [ ] El secret se pasa vía `env:`, no como argumento de `run:`.
- [ ] El step ejecuta `./deploy.sh`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los secrets se definen en Settings → Secrets and variables → Actions.
- Se referencian con `${{ secrets.NOMBRE }}` y se inyectan con `env:` en el step o el job.
- GitHub enmascara los secrets en los logs automáticamente.
- Nunca uses `run: echo ${{ secrets.X }}` — el valor quedaría expuesto en el proceso.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/secrets.yml
name: Secrets
on: push
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Desplegar
        env:
          API_TOKEN: ${{ secrets.API_TOKEN }}
        run: ./deploy.sh
```

</details>
