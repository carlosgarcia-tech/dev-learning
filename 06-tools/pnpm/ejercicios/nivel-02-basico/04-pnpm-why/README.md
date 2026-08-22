# 04 — pnpm why

## Enunciado

Descubre por qué un paquete está instalado.

## Requisitos

1. En `solucion/`, ejecuta `pnpm why <paquete>` para una dependencia.
2. Guarda la salida en `why.txt`.

## Pistas

- `pnpm why` muestra quién depende de ese paquete.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
pnpm why express > why.txt
```

</details>
