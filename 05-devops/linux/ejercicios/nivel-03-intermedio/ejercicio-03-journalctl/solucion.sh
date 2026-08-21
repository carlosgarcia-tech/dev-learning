#!/usr/bin/env bash
set -uo pipefail

journalctl -b --no-pager 2>/dev/null > log_arranque.txt || : > log_arranque.txt
journalctl -p err -b --no-pager 2>/dev/null > log_errores.txt || : > log_errores.txt
journalctl -k --no-pager 2>/dev/null > log_kernel.txt || : > log_kernel.txt
journalctl -p warning -b --no-pager 2>/dev/null | wc -l > resumen_prioridades.txt || echo 0 > resumen_prioridades.txt
