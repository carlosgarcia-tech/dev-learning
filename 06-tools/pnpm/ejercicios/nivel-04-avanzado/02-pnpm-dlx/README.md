# 02 — pnpm dlx

## Enunciado

Usa `pnpm dlx` para ejecutar un paquete sin instalarlo.

## Requisitos

1. Ejecuta `pnpm dlx cowsay "Hola"` y guarda la salida en `solucion/salida.txt`.
2. Verifica que cowsay no está en `package.json`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
pnpm dlx cowsay "Hola" > solucion/salida.txt
```

</details>
