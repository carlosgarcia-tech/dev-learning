# Ejercicio 01 — Workflow básico

- **Nivel:** 1/5
- **Tema:** workflow mínimo, un job, un step, `name`/`on`/`jobs`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un workflow de GitHub Actions **mínimo** en `.github/workflows/basico.yml` que:

1. Tenga el nombre `Basico`.
2. Se dispare con `push`.
3. Contenga **un solo job** llamado `hola` que corre en `ubuntu-latest`.
4. El job tenga **un solo step** que ejecute `echo "Hola CI/CD"`.

Este es el "Hola Mundo" de los pipelines: la estructura mínima válida.

## Requisitos

- [ ] El archivo existe en `.github/workflows/basico.yml`.
- [ ] El workflow tiene `name: Basico`.
- [ ] El trigger es `on: push`.
- [ ] Hay un job `hola` con `runs-on: ubuntu-latest`.
- [ ] El job tiene un step con `run: echo "Hola CI/CD"`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La estructura de un workflow es: `name`, `on`, `jobs`.
- `on: push` es la forma corta para un único trigger.
- Un job se define como clave bajo `jobs:` y lleva `runs-on` y `steps`.
- Un step usa `run:` para ejecutar un comando de shell o `uses:` para una action.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/basico.yml
name: Basico
on: push
jobs:
  hola:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Hola CI/CD"
```

</details>
