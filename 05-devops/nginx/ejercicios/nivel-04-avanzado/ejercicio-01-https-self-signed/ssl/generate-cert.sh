#!/usr/bin/env bash
# Genera un certificado self-signed para el ejercicio
set -euo pipefail
cd "$(dirname "$0")" || exit 1
mkdir -p ssl
[ -f ssl/selfsigned.key ] && [ -f ssl/selfsigned.crt ] && { echo "Cert ya existe"; exit 0; }
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout ssl/selfsigned.key \
  -out ssl/selfsigned.crt \
  -days 365 \
  -subj "/C=ES/ST=Madrid/L=Madrid/O=Dev/CN=localhost" 2>/dev/null
echo "Certificado generado en ssl/"
