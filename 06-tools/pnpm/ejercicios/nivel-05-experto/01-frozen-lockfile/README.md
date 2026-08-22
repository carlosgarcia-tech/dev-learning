# 01 — frozen-lockfile en CI

## Enunciado

Configura instalación estricta para CI.

## Requisitos

1. Explica en `respuesta.txt` qué hace `pnpm install --frozen-lockfile`.
2. Menciona en qué se diferencia de `pnpm install` normal.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
pnpm install --frozen-lockfile instala exactamente lo del pnpm-lock.yaml sin modificarlo. Si el lockfile no coincide con package.json, falla. Es ideal para CI porque garantiza reproducibilidad. pnpm install normal puede actualizar el lockfile.
```

</details>
