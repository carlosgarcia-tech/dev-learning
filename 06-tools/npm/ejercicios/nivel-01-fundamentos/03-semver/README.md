# 03 — Semver

## Enunciado

Comprende los rangos de versiones de semver.

## Requisitos

1. En `solucion/package.json`, fija `lodash` con prefijo `^`.
2. Fija `chalk` con prefijo `~`.
3. Fija `axios` con versión exacta (sin prefijo).

## Pistas

- `^1.2.3` permite 1.x.x.
- `~1.2.3` permite 1.2.x.
- `1.2.3` es exacta.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "dependencies": {
    "lodash": "^4.17.21",
    "chalk": "~5.3.0",
    "axios": "1.6.0"
  }
}
```

</details>
