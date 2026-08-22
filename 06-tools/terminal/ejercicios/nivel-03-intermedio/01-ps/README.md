# 01 — ps y procesos

## Enunciado

Lista procesos del sistema.

## Requisitos

1. Ejecuta `ps aux` y guarda la salida en `solucion/procesos.txt`.
2. Filtra los procesos que contengan "bash" y guárdalos en `bash-procs.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
ps aux > solucion/procesos.txt
ps aux | grep bash > solucion/bash-procs.txt
```

</details>
