# Ejercicio 03 — Checkout + run echo

- **Nivel:** 1/5
- **Tema:** `actions/checkout`, step con `uses` y `run`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un workflow en `.github/workflows/checkout.yml` que:

1. Se dispare en `push`.
2. Tenga un job `build` en `ubuntu-latest`.
3. El primer step use `actions/checkout@v4`.
4. El segundo step liste los archivos del repo con `ls -la`.
5. Un tercer step ejecute `echo "Checkout completado"`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/checkout.yml`.
- [ ] El job `build` usa `actions/checkout@v4`.
- [ ] Hay un step que ejecuta `ls -la`.
- [ ] Hay un step que ejecuta `echo "Checkout completado"`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `actions/checkout@v4` es la action oficial para clonar el repo en el runner.
- Sin checkout, el runner no tiene el código: cualquier comando que toque el repo falla.
- Se declara con `uses:` (no `run:`), y se puede pasar config con `with:`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/checkout.yml
name: Checkout
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ls -la
      - run: echo "Checkout completado"
```

</details>
