#!/usr/bin/env bash
# Script de apoyo: simula un despliegue al entorno indicado como $1.
# No realiza ningún despliegue real; solo imprime pasos para el ejercicio.
set -euo pipefail

ENTORNO="${1:-}"
if [ -z "$ENTORNO" ]; then
  echo "Uso: $0 <entorno>" >&2
  exit 1
fi

echo "==> Desplegando a entorno: ${ENTORNO}"
echo "==> $(date -u +%Y-%m-%dT%H:%M:%SZ) — deploy simulado completado"
