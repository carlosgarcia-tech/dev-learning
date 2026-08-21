#!/usr/bin/env bash
set -uo pipefail

if ! command -v ssh >/dev/null 2>&1 || ! command -v scp >/dev/null 2>&1; then
  echo "SSH no disponible"
  echo "SIN_CONEXION" > conexion.txt
  exit 0
fi

if ssh -o BatchMode=yes -o ConnectTimeout=3 localhost "echo CONEXION_OK" > conexion.txt 2>/dev/null; then
  echo "hola" > datos.txt
  scp -o BatchMode=yes -o ConnectTimeout=3 datos.txt localhost:/tmp/ 2>/dev/null || true
else
  echo "SIN_CONEXION" > conexion.txt
fi

exit 0
