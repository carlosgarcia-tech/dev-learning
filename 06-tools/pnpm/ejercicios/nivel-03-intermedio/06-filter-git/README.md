# 06 — Filtro por git diff

## Enunciado

Usa filtros basados en cambios de git.

## Requisitos

1. Explica en `respuesta.txt` cómo ejecutar tests solo en paquetes modificados desde `main`.
2. Da el comando exacto.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Para ejecutar tests solo en paquetes modificados desde main:
pnpm -r --filter "...[origin/main]" run test
```

</details>
