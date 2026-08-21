#!/usr/bin/env bash
wc -l < numeros.txt > total_lineas.txt
awk '{s+=$1} END {print s}' numeros.txt > suma.txt
cat numeros.txt | grep -E "^[0-9]+$" | wc -l > pares.txt
echo "Procesando datos..." | tee log_tee.txt
ls /no/existe > errores_y_salida.txt 2>&1 || true
