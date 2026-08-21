#!/usr/bin/env bash
set -euo pipefail

echo "Ejecutando rollback automático..."
kubectl rollout undo deployment/ci-cd-app
kubectl rollout status deployment/ci-cd-app --timeout=2m
echo "✅ Rollback completado"
