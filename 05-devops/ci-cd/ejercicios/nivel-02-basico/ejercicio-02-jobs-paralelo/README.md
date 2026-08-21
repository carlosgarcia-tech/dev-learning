# Ejercicio 08 — Jobs en paralelo

- **Nivel:** 2/5
- **Tema:** jobs sin `needs`, ejecución paralela por defecto
- **Tiempo estimado:** 15 min

## Enunciado

Crea un workflow en `.github/workflows/paralelo.yml` con **tres jobs** que corren en paralelo (sin `needs`):

1. `lint`: ejecuta `echo "Ejecutando lint..."`.
2. `unit`: ejecuta `echo "Ejecutando unit..."`.
3. `e2e`: ejecuta `echo "Ejecutando e2e..."`.

> Por defecto, los jobs sin `needs` corren en paralelo en runners distintos.

## Requisitos

- [ ] El archivo existe en `.github/workflows/paralelo.yml`.
- [ ] Hay tres jobs: `lint`, `unit`, `e2e`.
- [ ] Ningún job tiene `needs` (corren en paralelo).
- [ ] Cada job tiene `runs-on: ubuntu-latest` y un step con `echo`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En GitHub Actions, los jobs sin `needs` se ejecutan en paralelo automáticamente.
- Para secuenciarlos, usarías `needs:`. Aquí no lo hacemos para que corran a la vez.
- Cada job es una clave distinta bajo `jobs:`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/paralelo.yml
name: Paralelo
on: push
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Ejecutando lint..."
  unit:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Ejecutando unit..."
  e2e:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Ejecutando e2e..."
```

</details>
