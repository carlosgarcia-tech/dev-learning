#!/usr/bin/env bash
awk -F, 'NR>1 {s+=$2} END {print s}' ventas.csv > totales.txt
awk -F, 'NR>1 {s+=$2*$3} END {print s}' ventas.csv > ingresos.txt
awk -F, 'NR>1 {print $1}' ventas.csv | sort -u > productos_unicos.txt
awk -F, 'NR==1 || $1=="pan"' ventas.csv > ventas_pan.txt
awk 'END {print NR}' ventas.csv > resumen.txt
