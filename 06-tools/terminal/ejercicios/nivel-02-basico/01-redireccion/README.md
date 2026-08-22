# 01 — Redirección

## Enunciado

Practica la redirección de stdout y stderr.

## Requisitos

1. Crea `solucion/ejemplo.sh` que ejecute `ls /no-existe` y redirija stderr a `errores.txt`.
2. Ejecuta `echo "hola" > salida.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
ls /no-existe 2> errores.txt
echo "hola" > salida.txt
```

</details>
