#!/usr/bin/env bash
set -euo pipefail
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t miuser/app:multiarch \
  .
