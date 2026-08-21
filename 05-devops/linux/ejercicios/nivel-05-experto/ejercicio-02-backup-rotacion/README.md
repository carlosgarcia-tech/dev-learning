# Ejercicio 02 — Script de backup con rotación

- **Nivel:** 5/5
- **Tema:** *backup*, `tar`, rotación, retención, compresión, `find -mtime`
- **Tiempo estimado:** 40 min

## Enunciado

Escribe `solucion.sh` que implemente un sistema de backup con **rotación por retención**. El script:

1. Recibe dos argumentos: `ORIGEN` (directorio a respaldar) y `DESTINO` (directorio de backups).
   - `./solucion.sh origen datos_backups`
2. Crea un archivo comprimido `backup-<AAAA-MM-DD-HHMMSS>.tar.gz` en `DESTINO` con el contenido de `ORIGEN`.
3. Registra la operación en `DESTINO/backup.log` con timestamp, archivo creado y tamaño.
4. Implementa **rotación**: elimina los backups con más de `KEEP_DAYS` días (variable por defecto `KEEP_DAYS=7`), usando `find "$DESTINO" -name "backup-*.tar.gz" -mtime +$KEEP_DAYS -delete`.
5. No elimina el log ni archivos que no sean `backup-*.tar.gz`.

## Requisitos

- [ ] Al ejecutar `./solucion.sh origen datos_backups`, se crea `datos_backups/backup-<timestamp>.tar.gz`.
- [ ] El `.tar.gz` contiene los archivos de `origen/`.
- [ ] `datos_backups/backup.log` existe y contiene el nombre del backup creado.
- [ ] Si hay backups con más de `KEEP_DAYS` días, se eliminan (simulado en el test).
- [ ] Los archivos que no son `backup-*.tar.gz` (como el log) **no** se eliminan.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `timestamp=$(date +%Y-%m-%d-%H%M%S)` genera un timestamp único.
- `tar czf "$DESTINO/backup-$timestamp.tar.gz" -C "$ORIGEN" .` comprime el contenido.
- `stat -c %s archivo` da el tamaño en bytes.
- `find "$DESTINO" -name "backup-*.tar.gz" -mtime +7 -delete` borra los antiguos.
- Acepta `KEEP_DAYS` por variable de entorno: `${KEEP_DAYS:-7}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Uso: solucion.sh <origen> <destino>"
  exit 1
fi

ORIGEN="$1"
DESTINO="$2"
KEEP_DAYS="${KEEP_DAYS:-7}"

mkdir -p "$DESTINO"
timestamp=$(date +%Y-%m-%d-%H%M%S)
archivo="$DESTINO/backup-$timestamp.tar.gz"

tar czf "$archivo" -C "$ORIGEN" .
tamano=$(stat -c %s "$archivo")
echo "[$(date '+%F %T')] Backup creado: $archivo (tamaño: $tamano bytes)" >> "$DESTINO/backup.log"

find "$DESTINO" -name "backup-*.tar.gz" -mtime "+$KEEP_DAYS" -delete
```

</details>
