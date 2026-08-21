#!/usr/bin/env bash
# monitor.sh — Script de monitorización del sistema (solución de referencia)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${MON_CONF:-$SCRIPT_DIR/../config/mon.conf}"

# Cargar configuración
if [ -f "$CONF" ]; then
  # shellcheck disable=SC1090
  source "$CONF"
fi

ALERT_CPU="${ALERT_CPU:-80}"
ALERT_MEM="${ALERT_MEM:-90}"
ALERT_DISK="${ALERT_DISK:-90}"
LOG_DIR="${LOG_DIR:-/tmp/monitoreo}"

mkdir -p "$LOG_DIR"

# Recoger métricas
cpu_load=$(awk '{print $1}' /proc/loadavg 2>/dev/null || echo 0)
cores=$(nproc 2>/dev/null || echo 1)
cpu_pct=$(awk "BEGIN {printf \"%.0f\", ($cpu_load / $cores) * 100}")
mem_pct=$(free | awk '/Mem/ {printf "%.0f", $3/$2*100}' 2>/dev/null || echo 0)
disk_pct=$(df / | awk 'NR==2 {print $5}' | tr -d '%' 2>/dev/null || echo 0)
top_procs=$(ps aux --sort=-%cpu | head -6 | tail -5 | awk '{print $1,$2,$3,$4,$11}')

# Determinar estado
status="OK"
[ "$cpu_pct" -ge "$ALERT_CPU" ] && status="ALERT"
[ "$mem_pct" -ge "$ALERT_MEM" ] && status="ALERT"
[ "$disk_pct" -ge "$ALERT_DISK" ] && status="ALERT"

# Línea de log estructurada
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
log_line="$ts script=monitor status=$status cpu=$cpu_pct mem=$mem_pct disk=$disk_pct"
echo "$log_line" >> "$LOG_DIR/monitor.log"

# Alertas detalladas
if [ "$status" = "ALERT" ]; then
  echo "$ts ALERT cpu=$cpu_pct (umbral=$ALERT_CPU) mem=$mem_pct (umbral=$ALERT_MEM) disk=$disk_pct (umbral=$ALERT_DISK)" >> "$LOG_DIR/monitor.log"
  touch "$LOG_DIR/alert.flag"
fi

echo "$log_line"
