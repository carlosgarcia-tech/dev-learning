#!/usr/bin/env bash
# test.sh — Valida el proyecto integrador de monitorización y backups
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fail=0

# ---------------------------------------------------------------------------
# Preparar entorno aislado: copiar solución a bin/ (simulando que el alumno
# completó los TODO), con una config propia que apunte al directorio temporal.
# ---------------------------------------------------------------------------
mkdir -p "$TMP/bin" "$TMP/config" "$TMP/systemd" "$TMP/datos" "$TMP/backups"
cp "$HERE/solucion/monitor.sh" "$TMP/bin/monitor.sh"
cp "$HERE/solucion/backup.sh"  "$TMP/bin/backup.sh"
chmod +x "$TMP/bin/monitor.sh" "$TMP/bin/backup.sh"

cat > "$TMP/config/mon.conf" <<EOF
ALERT_CPU=10
ALERT_MEM=10
ALERT_DISK=10
LOG_DIR=$TMP/logs
BACKUP_ORIGEN=$TMP/datos
BACKUP_DESTINO=$TMP/backups
KEEP_DAYS=7
EOF

printf 'archivo importante\n' > "$TMP/datos/critico.txt"
printf 'config\n'             > "$TMP/datos/config.conf"

# ---------------------------------------------------------------------------
# Test 1: monitor.sh genera una línea de log
# ---------------------------------------------------------------------------
out=$(bash "$TMP/bin/monitor.sh" 2>/dev/null) || true
if [ -s "$TMP/logs/monitor.log" ]; then
  echo "OK monitor.sh escribió en monitor.log"
else
  echo "FAIL monitor.sh no generó monitor.log"; fail=1
fi

# ---------------------------------------------------------------------------
# Test 2: monitor.sh crea alert.flag cuando se supera un umbral
# ---------------------------------------------------------------------------
if [ -f "$TMP/logs/alert.flag" ]; then
  echo "OK monitor.sh creó alert.flag (umbral superado)"
else
  echo "FAIL monitor.sh no creó alert.flag con umbrales bajos"; fail=1
fi

# ---------------------------------------------------------------------------
# Test 3: el log tiene formato estructurado (timestamp + script= + status=)
# ---------------------------------------------------------------------------
linea=$(head -1 "$TMP/logs/monitor.log" 2>/dev/null || echo "")
if echo "$linea" | grep -qE 'script=monitor status=' ; then
  echo "OK log estructurado correctamente"
else
  echo "FAIL log no tiene formato estructurado: '$linea'"; fail=1
fi

# ---------------------------------------------------------------------------
# Test 4: backup.sh crea un .tar.gz con el contenido del origen
# ---------------------------------------------------------------------------
bash "$TMP/bin/backup.sh" "$TMP/datos" "$TMP/backups" >/dev/null 2>&1
backup_creado=$(find "$TMP/backups" -name "backup-*.tar.gz" | head -1)
if [ -n "$backup_creado" ]; then
  echo "OK backup.sh creó $backup_creado"
else
  echo "FAIL backup.sh no creó ningún backup"; fail=1
fi
if [ -n "$backup_creado" ]; then
  if tar tzf "$backup_creado" 2>/dev/null | grep -q "critico.txt"; then
    echo "OK el backup contiene critico.txt"
  else
    echo "FAIL el backup no contiene critico.txt"; fail=1
  fi
fi

# ---------------------------------------------------------------------------
# Test 5: backup.sh registra en backup.log
# ---------------------------------------------------------------------------
if [ -s "$TMP/backups/backup.log" ]; then
  echo "OK backup.log generado"
else
  echo "FAIL backup.log no existe o está vacío"; fail=1
fi

# ---------------------------------------------------------------------------
# Test 6: rotación elimina backups viejos pero no el log
# ---------------------------------------------------------------------------
# Crear un backup viejo (>7 días)
tar czf "$TMP/backups/backup-viejo.tar.gz" -C "$TMP/datos" .
touch -d "10 days ago" "$TMP/backups/backup-viejo.tar.gz"

# Crear un backup previo (dentro de retención) para asegurar que no se borra todo
touch -d "2 days ago" "$backup_creado"

bash "$TMP/bin/backup.sh" "$TMP/datos" "$TMP/backups" >/dev/null 2>&1

if [ ! -f "$TMP/backups/backup-viejo.tar.gz" ]; then
  echo "OK rotación eliminó el backup viejo"
else
  echo "FAIL la rotación no eliminó el backup viejo"; fail=1
fi

if [ -f "$TMP/backups/backup.log" ]; then
  echo "OK backup.log sobrevivió a la rotación"
else
  echo "FAIL backup.log fue eliminado por la rotación"; fail=1
fi

# ---------------------------------------------------------------------------
# Test 7: config/mon.conf define las variables requeridas
# ---------------------------------------------------------------------------
conf="$HERE/config/mon.conf"
for var in ALERT_CPU ALERT_MEM ALERT_DISK LOG_DIR; do
  if grep -q "^$var=" "$conf" 2>/dev/null; then
    echo "OK $var definida en mon.conf"
  else
    echo "FAIL $var no está definida en mon.conf"; fail=1
  fi
done

# ---------------------------------------------------------------------------
# Test 8: systemd timers tienen la configuración correcta
# ---------------------------------------------------------------------------
mt="$HERE/systemd/monitor.timer"
bt="$HERE/systemd/backup.timer"

if grep -q 'OnCalendar=\*:0/5' "$mt" 2>/dev/null; then
  echo "OK monitor.timer usa OnCalendar=*:0/5"
else
  echo "FAIL monitor.timer no usa OnCalendar=*:0/5"; fail=1
fi

if grep -q 'OnCalendar=\*-\*-\* 02:00:00' "$bt" 2>/dev/null; then
  echo "OK backup.timer usa OnCalendar=*-*-* 02:00:00"
else
  echo "FAIL backup.timer no usa OnCalendar=*-*-* 02:00:00"; fail=1
fi

if grep -q 'Persistent=true' "$bt" 2>/dev/null; then
  echo "OK backup.timer tiene Persistent=true"
else
  echo "FAIL backup.timer no tiene Persistent=true"; fail=1
fi

# ---------------------------------------------------------------------------
# Resultado final
# ---------------------------------------------------------------------------
echo
if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"
  exit 0
else
  echo "FAIL Tests fallaron"
  exit 1
fi
