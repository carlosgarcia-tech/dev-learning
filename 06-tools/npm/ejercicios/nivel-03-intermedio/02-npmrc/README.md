# 02 — Configurar .npmrc

## Enunciado

Crea un archivo `.npmrc` con configuración de registry y autenticación por scope.

## Requisitos

1. Crea `solucion/.npmrc`.
2. Configura el registry por defecto a `https://registry.npmjs.org/`.
3. Configura un scope `@miorg` para que use `https://npm.pkg.github.com/`.

## Pistas

- Sintaxis: `registry=URL` y `@scope:registry=URL`.

## Solución

<details>
<summary>Mostrar solución</summary>

```ini
registry=https://registry.npmjs.org/
@miorg:registry=https://npm.pkg.github.com/
```

</details>
