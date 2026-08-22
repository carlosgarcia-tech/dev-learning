#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "confianza\|ciega\|yolo" "$DIR/respuesta.txt" || { echo "No menciona confianza ciega"; exit 1; }
grep -qi "vago\|prompt" "$DIR/respuesta.txt" || { echo "No menciona prompts vagos"; exit 1; }
echo "OK"
