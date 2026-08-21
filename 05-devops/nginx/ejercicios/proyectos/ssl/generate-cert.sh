#!/usr/bin/env bash
# Genera certificado self-signed para el proyecto (dev/staging)
set -euo pipefail
cd "$(dirname "$0")" || exit 1
mkdir -p ssl
[ -f ssl/proxy.crt ] && [ -f ssl/proxy.key ] && { echo "Cert ya existe"; exit 0; }
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout ssl/proxy.key \
  -out ssl/proxy.crt \
  -days 365 \
  -subj "/C=ES/ST=Madrid/L=Madrid/O=DevLearning/CN=*.ejemplo.com" \
  -addext "subjectAltName=DNS:auth.ejemplo.com,DNS:api.ejemplo.com,DNS:web.ejemplo.com" 2>/dev/null \
  || openssl req -x509 -nodes -newkey rsa:2048 \
     -keyout ssl/proxy.key -out ssl/proxy.crt -days 365 \
     -subj "/C=ES/ST=Madrid/L=Madrid/O=DevLearning/CN=*.ejemplo.com" 2>/dev/null
echo "Certificado generado en ssl/ (proxy.crt + proxy.key)"
