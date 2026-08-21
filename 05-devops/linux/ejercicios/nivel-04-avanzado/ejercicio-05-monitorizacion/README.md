# Ejercicio 05 — Script de monitorización del sistema

- **Nivel:** 4/5
- **Tema:** `uptime`, `free`, `df`, `ps`, `top`, formateo con `awk`
- **Tiempo estimado:** 35 min

## Enunciado

Escribe `solucion.sh` que genere un **informe de monitorización** en `informe.txt` con varias secciones. El script debe ser portable y no fallar si algún comando no está disponible.

El `informe.txt` debe contener:

1. Una cabecera con la fecha: `=== Informe del sistema - <fecha> ===` (usa `date`).
2. Sección `## CPU` con la salida de `uptime`.
3. Sección `## Memoria` con la salida de `free -h` (o `free` si `-h` no existe).
4. Sección `## Disco` con la salida de `df -h /`.
5. Sección `## Top 5 CPU` con los 5 procesos que más CPU consumen: `ps aux --sort=-%cpu | head -6` (cabecera + 5).
6. Sección `## Top 5 Memoria` con `ps aux --sort=-%mem | head -6`.
7. Sección `## Resumen` con dos líneas:
   - `Load average: <valor>` (extraído con `awk` de `uptime`).
   - `Memoria disponible: <valor>` (extraído con `awk` de `free`).

El informe debe ser legible y cada sección estar separada por una línea en blanco.

## Requisitos

- [ ] `informe.txt` existe y no está vacío.
- [ ] Contiene la cabecera `=== Informe del sistema`.
- [ ] Contiene `## CPU`, `## Memoria`, `## Disco`, `## Top 5 CPU`, `## Top 5 Memoria` y `## Resumen`.
- [ ] La sección `## Resumen` contiene `Load average:` y `Memoria disponible:`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Redirige cada comando al archivo con `>>` para ir añadiendo.
- `uptime | awk -F'load average:' '{print $2}' | awk '{print $1}'` extrae el load average.
- `free | awk '/Mem/ {print $7}'` da la memoria disponible (columna `available` o `free`).
- Usa `ps aux --sort=-%cpu | head -6` para los top procesos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

{
  echo "=== Informe del sistema - $(date) ==="
  echo

  echo "## CPU"
  uptime
  echo

  echo "## Memoria"
  free -h 2>/dev/null || free
  echo

  echo "## Disco"
  df -h /
  echo

  echo "## Top 5 CPU"
  ps aux --sort=-%cpu | head -6
  echo

  echo "## Top 5 Memoria"
  ps aux --sort=-%mem | head -6
  echo

  echo "## Resumen"
  load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
  mem=$(free | awk '/Mem/ {print $7}')
  echo "Load average: $load"
  echo "Memoria disponible: $mem"
} > informe.txt
```

</details>
