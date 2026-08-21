# Ejercicio 10 — Job secuencial (needs)

- **Nivel:** 2/5
- **Tema:** `needs`, encadenar jobs, orden de ejecución
- **Tiempo estimado:** 15 min

## Enunciado

Crea un workflow en `.github/workflows/secuencial.yml` con **tres jobs encadenados** en secuencia:

1. `build`: ejecuta `echo "Compilando..."`.
2. `test`: depende de `build` con `needs: build`, ejecuta `echo "Testeando..."`.
3. `deploy`: depende de `test` con `needs: test`, ejecuta `echo "Desplegando..."`.

> Con `needs`, cada job espera al anterior. El orden de ejecución es lineal: build → test → deploy.

## Requisitos

- [ ] El archivo existe en `.github/workflows/secuencial.yml`.
- [ ] El job `test` tiene `needs: build`.
- [ ] El job `deploy` tiene `needs: test`.
- [ ] Los tres jobs tienen `runs-on: ubuntu-latest`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `needs: build` hace que `test` espere a que `build` termine con éxito.
- Puedes encadenar varios `needs` en una lista: `needs: [build, lint]`.
- Sin `needs`, los jobs corren en paralelo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/secuencial.yml
name: Secuencial
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Compilando..."
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testeando..."
  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: echo "Desplegando..."
```

</details>
