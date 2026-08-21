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
