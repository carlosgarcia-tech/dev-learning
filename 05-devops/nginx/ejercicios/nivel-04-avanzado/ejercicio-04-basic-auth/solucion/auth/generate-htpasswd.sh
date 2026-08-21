#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")" || exit 1
if command -v htpasswd >/dev/null 2>&1; then
    htpasswd -bc .htpasswd admin secret123 2>/dev/null
else
    SALT=$(openssl rand -base64 3 2>/dev/null || echo "abc")
    PASS="secret123"
    HASH=$(openssl passwd -apr1 -salt "$SALT" "$PASS" 2>/dev/null || echo "")
    [ -z "$HASH" ] && { echo "FAIL: no se pudo generar .htpasswd"; exit 1; }
    printf 'admin:%s\n' "$HASH" > .htpasswd
fi
echo "Generado .htpasswd (admin:secret123)"
