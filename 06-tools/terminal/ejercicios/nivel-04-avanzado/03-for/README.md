# 03 — Bucle for

## Enunciado

Crea un script con un bucle for.

## Requisitos

1. Crea `solucion/loop.sh` que imprima los números del 1 al 10.
2. Guarde la salida en `salida.txt` al ejecutarse.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
for i in {1..10}; do
  echo $i
done > salida.txt
```

</details>
