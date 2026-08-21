# Ejercicio 03 — Análisis de logs con `awk`

- **Nivel:** 5/5
- **Tema:** `awk` avanzado, arrays asociativos, agregaciones, filtros, formato
- **Tiempo estimado:** 40 min

## Enunciado

`setup.sh` crea `acceso.log`, un log de servidor web con este formato:

```
192.168.1.10 - - [20/May/2025:10:00:01] "GET /index.html" 200
192.168.1.11 - - [20/May/2025:10:00:05] "POST /api/login" 401
192.168.1.10 - - [20/May/2025:10:00:10] "GET /about" 200
192.168.1.12 - - [20/May/2025:10:00:15] "GET /index.html" 200
192.168.1.11 - - [20/May/2025:10:00:20] "POST /api/login" 200
```

Escribe `solucion.sh` que genere estos informes (todos con `awk`):

1. `peticiones_por_ip.txt` — cuenta cuántas peticiones hizo cada IP (1ª columna). Formato: `IP: <n>`.
2. `codigos_estado.txt` — cuenta cuántas peticiones hay por cada código HTTP (última columna). Formato: `codigo <n>: <n>`.
3. `peticiones_4xx_5xx.txt` — solo las líneas cuyo código HTTP empieza por `4` o `5` (errores).
4. `ip_top.txt` — la IP con más peticiones y su recuento. Formato: `IP_TOP <ip> <n>`.
5. `resumen.txt` — un resumen con: total de peticiones, IPs distintas y nº de errores (4xx/5xx).

## Requisitos

- [ ] `peticiones_por_ip.txt` contiene `192.168.1.10: 2` y `192.168.1.11: 2` (formato flexible).
- [ ] `codigos_estado.txt` contiene `200` y `401` con sus cuentas.
- [ ] `peticiones_4xx_5xx.txt` contiene solo líneas con códigos 4xx o 5xx.
- [ ] `ip_top.txt` contiene una IP y su recuento.
- [ ] `resumen.txt` contiene el total de peticiones y nº de errores.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `awk '{count[$1]++} END {for (ip in count) print ip": "count[ip]}'` agrupa por IP.
- Para códigos: `awk '{count[$NF]++} END {for (c in count) print c": "count[c]}'`.
- Filtrar errores: `awk '$NF ~ /^[45]/'` (código que empieza por 4 o 5).
- Para el top: ordena con `sort -k2 -rn | head -1`.
- Cuenta IPs únicas con `awk '{print $1}' | sort -u | wc -l`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
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
```

</details>
