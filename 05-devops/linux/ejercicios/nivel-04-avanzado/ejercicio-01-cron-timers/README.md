# Ejercicio 01 — Tareas programadas con `cron` y `systemd timers`

- **Nivel:** 4/5
- **Tema:** `crontab`, formato de 5 campos, `systemd --user` timers
- **Tiempo estimado:** 30 min

## Enunciado

Escribe `solucion.sh` que genere **archivos de configuración** de planificación (sin instalarlos en el sistema, para que el test sea seguro y reproducible):

1. Crea `tarea.cron` con una línea válida que ejecute `/usr/local/bin/backup.sh` **cada día a las 02:30**:
   ```
   30 2 * * * /usr/local/bin/backup.sh
   ```
2. Crea `limpieza.cron` con una línea que ejecute `/usr/local/bin/limpiar.sh` **cada domingo a las 03:00**:
   ```
   0 3 * * 0 /usr/local/bin/limpiar.sh
   ```
3. Crea un **timer de systemd de usuario** `backup.timer` con contenido:
   ```ini
   [Unit]
   Description=Backup diario

   [Timer]
   OnCalendar=*-*-* 02:30:00
   Persistent=true

   [Install]
   WantedBy=timers.target
   ```
4. Crea el **service** asociado `backup.service`:
   ```ini
   [Unit]
   Description=Backup diario

   [Service]
   Type=oneshot
   ExecStart=/usr/local/bin/backup.sh
   ```
5. Valida con `cron` que el formato de `tarea.cron` es correcto: crea un *crontab temporal* con esa línea y comprueba que `crontab -l` lo lista. Como esto requiere modificar el crontab real, el test verifica el contenido del archivo en su lugar.

## Requisitos

- [ ] `tarea.cron` contiene exactamente `30 2 * * * /usr/local/bin/backup.sh`.
- [ ] `limpieza.cron` contiene `0 3 * * 0 /usr/local/bin/limpiar.sh`.
- [ ] `backup.timer` tiene `OnCalendar=*-*-* 02:30:00` y `Persistent=true`.
- [ ] `backup.service` tiene `ExecStart=/usr/local/bin/backup.sh`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `cat > archivo <<'EOF' ... EOF` para escribir archivos multilínea sin expansión.
- Los 5 campos de cron: `min hora diames mes diasemana`.
- `OnCalendar=*-*-* 02:30:00` es la forma de systemd para "cada día a las 02:30".

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "30 2 * * * /usr/local/bin/backup.sh" > tarea.cron
echo "0 3 * * 0 /usr/local/bin/limpiar.sh" > limpieza.cron

cat > backup.timer <<'EOF'
[Unit]
Description=Backup diario

[Timer]
OnCalendar=*-*-* 02:30:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > backup.service <<'EOF'
[Unit]
Description=Backup diario

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF
```

</details>
