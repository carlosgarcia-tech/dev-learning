# Ejercicio 05 — Pipeline dinámico con matrices
- **Nivel:** 4/5
- **Tema:** Pipelines dinámicos: `$GITHUB_OUTPUT` y `fromJSON` para matrices generadas en runtime
- **Tiempo estimado:** 55 min

## Enunciado

Quieres que tu pipeline **genere dinámicamente** la lista de módulos a construir leyendo un archivo de configuración `config.json`, y que un segundo job ejecute una *matrix* con esos módulos.

Diseña un workflow en `.github/workflows/dinamico.yml` que:

1. Tenga un job `generar` que:
   - lea `config.json`;
   - produzca un JSON de matriz con `$GITHUB_OUTPUT` (clave `matriz`);
   - exponga ese JSON en `outputs.matriz` del job.
2. Tenga un job `ejecutar` que:
   - dependa de `generar` (`needs: generar`);
   - use `strategy.matrix` con `fromJSON(needs.generar.outputs.matriz)`.

> Se incluye un `config.json` de ejemplo con la lista de módulos.

## Requisitos
- [ ] El job `generar` escribe en `$GITHUB_OUTPUT` (o `GITHUB_OUTPUT`).
- [ ] El job `ejecutar` usa `fromJSON` dentro de `strategy.matrix`.
- [ ] El job `ejecutar` depende de `generar` con `needs`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas
<details><summary>Mostrar pistas</summary>

- Para escribir un output desde un step:
  ```yaml
  - id: gen
    run: echo "matriz=...JSON..." >> "$GITHUB_OUTPUT"
  ```
  El JSON debe estar en **una sola línea** (usa `jq -c` si lo construyes desde un archivo).
- El job debe declarar `outputs:` para exponer el valor a otros jobs:
  ```yaml
  outputs:
    matriz: ${{ steps.gen.outputs.matriz }}
  ```
- En el job consumidor, la matrix se alimenta con `fromJSON`:
  ```yaml
  strategy:
    matrix:
      modulo: ${{ fromJSON(needs.generar.outputs.matriz) }}
  ```
- `fromJSON` es la función de GitHub Actions que parsea un string JSON en un valor usable (lista u objeto).

</details>

## Solución
<details><summary>Mostrar solución</summary>

```yaml
name: Pipeline dinámico
on: push

jobs:
  generar:
    runs-on: ubuntu-latest
    outputs:
      matriz: ${{ steps.gen.outputs.matriz }}
    steps:
      - uses: actions/checkout@v4
      - id: gen
        run: |
          MATRIZ=$(jq -c '[.modulos[] | {nombre, version}]' config.json)
          echo "matriz=$MATRIZ" >> "$GITHUB_OUTPUT"

  ejecutar:
    needs: generar
    runs-on: ubuntu-latest
    strategy:
      matrix:
        modulo: ${{ fromJSON(needs.generar.outputs.matriz) }}
    steps:
      - uses: actions/checkout@v4
      - run: echo "Construyendo ${{ matrix.modulo.nombre }} @ ${{ matrix.modulo.version }}"
```

`config.json`:

```json
{
  "modulos": [
    { "nombre": "api", "version": "1.0.0" },
    { "nombre": "web", "version": "2.1.0" },
    { "nombre": "worker", "version": "0.5.0" }
  ]
}
```

</details>
