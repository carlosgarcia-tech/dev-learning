#!/usr/bin/env bash
awk '{count[$1]++} END {for (ip in count) print ip": "count[ip]}' acceso.log > peticiones_por_ip.txt

awk '{count[$NF]++} END {for (c in count) print "codigo "c": "count[c]}' acceso.log > codigos_estado.txt

awk '$NF ~ /^[45]/' acceso.log > peticiones_4xx_5xx.txt

awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}' acceso.log \
  | sort -k2 -rn | head -1 | awk '{print "IP_TOP "$1" "$2}' > ip_top.txt

{
  total=$(wc -l < acceso.log)
  ips=$(awk '{print $1}' acceso.log | sort -u | wc -l)
  errores=$(awk '$NF ~ /^[45]/' acceso.log | wc -l)
  echo "Total de peticiones: $total"
  echo "IPs distintas: $ips"
  echo "Errores (4xx/5xx): $errores"
} > resumen.txt
