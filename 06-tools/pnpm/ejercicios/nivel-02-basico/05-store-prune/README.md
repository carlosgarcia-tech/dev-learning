# 05 — Store prune

## Enunciado

Limpia el store de paquetes no referenciados.

## Requisitos

1. Ejecuta `pnpm store prune`.
2. Guarda la salida en `solucion/prune.txt`.
3. Explica en `respuesta.txt` qué hace prune.

## Pistas

- Elimina paquetes del store que ningún proyecto referencia.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
pnpm store prune > solucion/prune.txt 2>&1
echo "pnpm store prune elimina del store global los paquetes que ningún proyecto referencia, liberando espacio." > solucion/respuesta.txt
```

</details>
