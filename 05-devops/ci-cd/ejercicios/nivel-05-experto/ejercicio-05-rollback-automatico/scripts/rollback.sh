#!/usr/bin/env bash
# scripts/rollback.sh
set -euo pipefail
echo "Ejecutando rollback..."
kubectl rollout undo deployment/mi-app
kubectl rollout status deployment/mi-app --timeout=2m
echo "Rollback completado"
