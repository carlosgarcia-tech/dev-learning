# 01 — Variables y sustitución

## Enunciado

Crea un script que use variables y sustitución de comandos.

## Requisitos

1. Crea `solucion/script.sh` que defina una variable `NOMBRE` con tu nombre.
2. Use sustitución de comandos para guardar la fecha actual en `FECHA`.
3. Imprima "Hola, $NOMBRE. Hoy es $FECHA".

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
NOMBRE="Ada"
FECHA=$(date +%Y-%m-%d)
echo "Hola, $NOMBRE. Hoy es $FECHA"
```

</details>
