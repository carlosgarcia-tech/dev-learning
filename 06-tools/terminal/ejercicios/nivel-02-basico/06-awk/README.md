# 06 — awk

## Enunciado

Usa awk para extraer columnas.

## Requisitos

1. Crea `solucion/datos.csv` con 3 columnas (nombre, edad, ciudad).
2. Usa `awk` para extraer solo la columna 1 (nombres) y guárdala en `nombres.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
echo -e "Ada,36,London\nBob,25,Paris\nCarol,42,Berlin" > solucion/datos.csv
awk -F, '{print $1}' solucion/datos.csv > solucion/nombres.txt
```

</details>
