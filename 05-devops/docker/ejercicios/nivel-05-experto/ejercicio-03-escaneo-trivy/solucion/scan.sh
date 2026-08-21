#!/usr/bin/env bash
set -euo pipefail
IMG="ejercicio-trivy:latest"
docker build -t "$IMG" .
trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMG"
echo "OK: sin vulnerabilidades HIGH/CRITICAL"
