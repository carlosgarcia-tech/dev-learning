# Ejercicio 06 — Diagnóstico de rendimiento con `strace`

- **Nivel:** 5/5
- **Tema:** `strace`, syscalls, `ltrace`, diagnóstico de procesos
- **Tiempo estimado:** 45 min

## Enunciado

`strace` rastrea las llamadas al sistema de un proceso, permitiendo diagnosticar cuelgues, archivos abiertos o errores ocultos.

Escribe `solucion.sh` que genere varios informes de diagnóstico:

1. `syscalls_cat.txt` — rastrea `cat /etc/passwd` y guarda solo las llamadas `openat`:
   ```
   strace -e trace=openat cat /etc/passwd 2>&1 | head -20 > syscalls_cat.txt
   ```

2. `resumen_syscalls.txt` — rastrea `ls /tmp` y genera un **resumen estadístico** de syscalls con `-c`:
   ```
   strace -c ls /tmp 2>&1 > resumen_syscalls.txt
   ```

3. `archivos_abiertos.txt` — rastrea `cat /etc/hostname` filtrando llamadas que abran archivos (`openat`, `open`):
   ```
   strace -e trace=%file cat /etc/hostname 2>&1 | head -20 > archivos_abiertos.txt
   ```

4. `comparacion.txt` — un análisis escrito (generado por ti, no por strace) que explique en 3-5 líneas qué información aporta `strace -c` y por qué es útil para diagnosticar rendimiento.

5. Si `strace` no está disponible, todos los archivos `.txt` deben contener `strace no disponible` y el script no debe fallar.

## Requisitos

- [ ] `syscalls_cat.txt` existe y no está vacío.
- [ ] `resumen_syscalls.txt` existe y no está vacío.
- [ ] `archivos_abiertos.txt` existe y no está vacío.
- [ ] `comparacion.txt` existe, no está vacío y menciona `strace`.
- [ ] El script no falla aunque `strace` no esté instalado.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `command -v strace` comprueba si está instalado.
- `strace -e trace=openat` filtra solo llamadas `openat`.
- `strace -c` muestra un resumen con tiempo, nº de llamadas y errores por syscall.
- `2>&1` redirige stderr (donde strace escribe) a stdout para capturarlo.
- Si strace no está, escribe `strace no disponible` en cada archivo con `echo`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
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
```

</details>
