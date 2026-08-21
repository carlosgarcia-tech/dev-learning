#!/usr/bin/env bash
set -uo pipefail

if ! command -v strace >/dev/null 2>&1; then
  echo "strace no disponible" > syscalls_cat.txt
  echo "strace no disponible" > resumen_syscalls.txt
  echo "strace no disponible" > archivos_abiertos.txt
  echo "strace no disponible para redactar comparacion" > comparacion.txt
  exit 0
fi

strace -e trace=openat cat /etc/passwd 2>&1 | head -20 > syscalls_cat.txt || echo "error en strace" > syscalls_cat.txt
strace -c ls /tmp 2>&1 > resumen_syscalls.txt || echo "error en strace" > resumen_syscalls.txt
strace -e trace=%file cat /etc/hostname 2>&1 | head -20 > archivos_abiertos.txt || echo "error en strace" > archivos_abiertos.txt

cat > comparacion.txt <<'EOF'
strace -c muestra un resumen estadístico de las llamadas al sistema
que hace un programa: cuántas llamadas de cada tipo, cuánto tiempo
consumen y cuántas fallan. Es útil para diagnosticar rendimiento porque
permite identificar qué syscalls dominan el tiempo de ejecución (p. ej.
muchas llamadas openat o read indican I/O intensivo) y localizar
llamadas erróneas que ralentizan el programa sin abortarlo.
EOF
