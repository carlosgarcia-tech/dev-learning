# 02 — Background con &

## Enunciado

Ejecuta procesos en background.

## Requisitos

1. Ejecuta `sleep 100 &` y guarda el PID en `solucion/pid.txt`.
2. Usa `jobs` para listar trabajos y guarda en `jobs.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
sleep 100 &
echo $! > solucion/pid.txt
jobs > solucion/jobs.txt 2>&1 || true
```

</details>
