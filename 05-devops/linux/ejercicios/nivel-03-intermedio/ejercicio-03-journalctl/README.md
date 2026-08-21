# Ejercicio 03 — Consultar logs con `journalctl`

- **Nivel:** 3/5
- **Tema:** `journalctl`, `-u`, `-b`, `-p`, `--since`, `--no-pager`
- **Tiempo estimado:** 25 min

## Enunciado

Escribe `solucion.sh` que genere varios informes de logs usando `journalctl`. Como los permisos del journal varían entre sistemas, cada consulta debe usar `--no-pager` y redirigir errores a `/dev/null`, de modo que el script no aborte.

1. `log_arranque.txt` — mensajes desde el último arranque (`journalctl -b --no-pager`).
2. `log_errores.txt` — entradas de prioridad `err` o superior (`journalctl -p err -b --no-pager`).
3. `log_kernel.txt` — mensajes del kernel (`journalctl -k --no-pager`).
4. `resumen_prioridades.txt` — cuenta de mensajes por prioridad usando `journalctl -p warning -b --no-pager | wc -l` (al menos debe contener un número).
5. Si el sistema no tiene journal disponible, todos los archivos deben crearse vacíos (no debe fallar el script).

## Requisitos

- [ ] Existen `log_arranque.txt`, `log_errores.txt`, `log_kernel.txt` y `resumen_prioridades.txt`.
- [ ] Ninguno hace que el script aborte con error.
- [ ] Si el journal está disponible, `log_arranque.txt` no está vacío.
- [ ] `resumen_prioridades.txt` contiene un número.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `journalctl -b` muestra desde el arranque actual; añade `--no-pager` para usarlo en scripts.
- `journalctl -p err -b` filtra por prioridad error.
- `journalctl -k` muestra solo mensajes del kernel.
- Redirige `2>/dev/null` y añade `|| true` para tolerar la ausencia de journal.
- Para contar: `journalctl ... | wc -l > archivo`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

journalctl -b --no-pager 2>/dev/null > log_arranque.txt || : > log_arranque.txt
journalctl -p err -b --no-pager 2>/dev/null > log_errores.txt || : > log_errores.txt
journalctl -k --no-pager 2>/dev/null > log_kernel.txt || : > log_kernel.txt
journalctl -p warning -b --no-pager 2>/dev/null | wc -l > resumen_prioridades.txt || echo 0 > resumen_prioridades.txt
```

</details>
