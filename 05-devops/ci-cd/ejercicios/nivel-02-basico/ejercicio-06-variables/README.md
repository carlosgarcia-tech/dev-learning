# Ejercicio 12 — Variables

- **Nivel:** 2/5
- **Tema:** `env`, variables de entorno, `vars`, interpolación
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/variables.yml` que:

1. Se dispare en `push`.
2. Defina variables a nivel de workflow con `env:`: `ENTORNO: dev` y `REGISTRY: ghcr.io`.
3. Tenga un job `info` en `ubuntu-latest`.
4. Un step que ejecute `echo "Entorno: $ENTORNO"` (usa la variable de entorno).
5. Un step que ejecute `echo "Registry: ${{ env.REGISTRY }}"` (usa la sintaxis de expresión).

> Las variables `env:` del workflow están disponibles en todos los jobs y steps.

## Requisitos

- [ ] El archivo existe en `.github/workflows/variables.yml`.
- [ ] Hay `env:` a nivel de workflow con `ENTORNO` y `REGISTRY`.
- [ ] Un step usa `$ENTORNO` o `${{ env.ENTORNO }}`.
- [ ] Un step usa `$REGISTRY` o `${{ env.REGISTRY }}`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `env:` puede definirse a nivel de workflow, de job o de step.
- Dentro de `run:`, las variables se usan como `$ENTORNO` (shell) o `${{ env.ENTORNO }}` (expresión).
- Las variables `vars.*` son las no secretas definidas en la UI (diferentes de `env`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/variables.yml
name: Variables
on: push
env:
  ENTORNO: dev
  REGISTRY: ghcr.io
jobs:
  info:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Entorno: $ENTORNO"
      - run: echo "Registry: ${{ env.REGISTRY }}"
```

</details>
