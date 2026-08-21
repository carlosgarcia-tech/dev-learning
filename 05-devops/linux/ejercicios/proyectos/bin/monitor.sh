#!/usr/bin/env bash
# monitor.sh — Script de monitorización del sistema
# Recoge métricas de CPU, memoria, disco y procesos, y genera alertas.
set -euo pipefail

# TODO: cargar configuración desde config/mon.conf (source o parseo manual)
# Pista: SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#        CONF="$SCRIPT_DIR/../config/mon.conf"

# TODO: crear LOG_DIR si no existe

# TODO: recoger métricas
# CPU (load average): awk '{print $1}' /proc/loadavg
# Memoria (% usado): free | awk '/Mem/ {printf "%.0f", $3/$2*100}'
# Disco (% usado /): df / | awk 'NR==2 {print $5}' | tr -d '%'

# TODO: construir línea de log estructurada
# Formato: 2025-08-20T10:00:00 script=monitor status=OK cpu=0.45 mem=62 disk=78

# TODO: comprobar umbrales y generar alerta (alert.flag) si se superan

# TODO: escribir log en $LOG_DIR/monitor.log

echo "(starter) monitor.sh no implementado todavía"
