#!/usr/bin/env bash
set -uo pipefail

# 1. Diagnóstico con lsof
if command -v lsof >/dev/null 2>&1; then
  lsof -p $$ > abiertos.txt 2>/dev/null || echo "lsof sin permisos" > abiertos.txt
  lsof -i -P -n 2>/dev/null | head -20 > puertos.txt || echo "sin sockets visibles" > puertos.txt
else
  echo "lsof no disponible" > abiertos.txt
  echo "lsof no disponible" > puertos.txt
fi

# 2. Sincronización con rsync
mkdir -p destino
if command -v rsync >/dev/null 2>&1; then
  rsync -av origen/ destino/ >/dev/null 2>&1
  echo "archivo extra" > origen/extra.txt
  rsync -av origen/ destino/ > sync_log.txt 2>&1
else
  echo "rsync no disponible, usando cp" > sync_log.txt
  cp -r origen/. destino/
  echo "archivo extra" > origen/extra.txt
  cp -r origen/. destino/
fi
