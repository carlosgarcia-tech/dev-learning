# 05 — Phantom dependencies

## Enunciado

Explica el problema de las phantom dependencies en monorepos.

## Requisitos

1. Crea `solucion/respuesta.txt`.
2. Explica qué es una phantom dependency.
3. Menciona por qué pnpm las evita.

## Pistas

- Ocurren cuando un paquete usa una dependencia que no declaró pero está disponible por hoisting.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Phantom dependency: un paquete importa una dependencia que no declaró en su package.json, pero que está disponible porque otra dependencia la trajo (hoisting). Es frágil: si la otra dependencia desaparece, se rompe.
pnpm las evita con su estructura de node_modules estricta (solo lo declarado es accesible).
```

</details>
