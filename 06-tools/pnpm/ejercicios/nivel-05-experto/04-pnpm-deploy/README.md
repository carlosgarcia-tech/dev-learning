# 04 — pnpm deploy

## Enunciado

Usa `pnpm deploy` para extraer un paquete del monorepo.

## Requisitos

1. Explica en `respuesta.txt` qué hace `pnpm deploy --filter=@miorg/api --prod ./dist`.
2. Menciona un caso de uso.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
pnpm deploy --filter=@miorg/api --prod ./dist extrae el paquete @miorg/api con sus dependencias de producción a la carpeta ./dist, sin devDependencies ni código de otros paquetes.
Caso de uso: copiar solo lo necesario a una imagen Docker pequeña.
```

</details>
