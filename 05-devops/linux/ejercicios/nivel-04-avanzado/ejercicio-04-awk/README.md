# Ejercicio 04 — Procesar datos con `awk`

- **Nivel:** 4/5
- **Tema:** `awk`, campos `$1`/`$2`, `-F`, `END`, `NR`, `NF`, filtros
- **Tiempo estimado:** 30 min

## Enunciado

`setup.sh` crea `ventas.csv` (separado por comas):

```csv
producto,cantidad,precio
manzana,10,0.50
pan,5,1.20
leche,3,1.00
pan,8,1.20
manzana,20,0.50
```

Escribe `solucion.sh` que genere:

1. `totales.txt` — el total de unidades vendidas (suma de la columna `cantidad`): `awk -F, 'NR>1 {s+=$2} END {print s}'`.
2. `ingresos.txt` — el ingreso total (`cantidad * precio` por fila, sumado): `awk -F, 'NR>1 {s+=$2*$3} END {print s}'`.
3. `productos_unicos.txt` — lista de productos distintos (sin la cabecera) usando `awk -F, 'NR>1 {print $1}' | sort -u`.
4. `ventas_pan.txt` — solo las filas cuyo producto es `pan` (con cabecera): combina `awk -F, 'NR==1 || $1=="pan"'`.
5. `resumen.txt` — cuenta de líneas totales (incluida cabecera) con `awk 'END {print NR}'`.

## Requisitos

- [ ] `totales.txt` contiene `46` (10+5+3+8+20).
- [ ] `ingresos.txt` contiene `33` (5 + 6 + 3 + 9.6 + 10 = 33.6 → `33` si se trunca; el test acepta `33` o `33.6`).
- [ ] `productos_unicos.txt` contiene `manzana`, `pan` y `leche` (sin duplicados).
- [ ] `ventas_pan.txt` contiene la cabecera y 2 filas de `pan`.
- [ ] `resumen.txt` contiene `6` (6 líneas contando cabecera).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `-F,` usa la coma como separador de campos.
- `NR` es el número de línea actual; `NR>1` salta la cabecera.
- `$2` es la 2ª columna (cantidad), `$3` la 3ª (precio).
- `END {print s}` se ejecuta al final con el acumulado.
- `sort -u` elimina duplicados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
awk -F, 'NR>1 {s+=$2} END {print s}' ventas.csv > totales.txt
awk -F, 'NR>1 {s+=$2*$3} END {print s}' ventas.csv > ingresos.txt
awk -F, 'NR>1 {print $1}' ventas.csv | sort -u > productos_unicos.txt
awk -F, 'NR==1 || $1=="pan"' ventas.csv > ventas_pan.txt
awk 'END {print NR}' ventas.csv > resumen.txt
```

</details>
