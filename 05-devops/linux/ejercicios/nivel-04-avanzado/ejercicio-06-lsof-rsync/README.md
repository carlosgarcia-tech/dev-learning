# Ejercicio 06 — Diagnóstico con `lsof` y sincronización con `rsync`

- **Nivel:** 4/5
- **Tema:** `lsof`, archivos/puertos abiertos, `rsync`, sincronización
- **Tiempo estimado:** 35 min

## Enunciado

`setup.sh` crea dos carpetas: `origen/` (con varios archivos) y `destino/` (vacía).

Escribe `solucion.sh` que:

1. **Diagnóstico con `lsof`:**
   - Guarda en `abiertos.txt` la lista de archivos abiertos por el proceso actual (`lsof -p $$`).
   - Guarda en `puertos.txt` los sockets de red a la escucha (`lsof -i -P -n 2>/dev/null | head -20` o `ss -tlnp`).
   - Si `lsof` no existe, ambos archivos deben contener `lsof no disponible`.
2. **Sincronización con `rsync`:**
   - Sincroniza el contenido de `origen/` en `destino/` con `rsync -av origen/ destino/`.
   - Crea un archivo nuevo en `origen/` (`extra.txt`), vuelve a sincronizar y verifica que aparece en `destino/`.
   - Guarda la salida de la segunda sincronización en `sync_log.txt`.

> Si `rsync` no está instalado, el script debe copiar con `cp -r` como fallback y escribir `rsync no disponible, usando cp` en `sync_log.txt`.

## Requisitos

- [ ] `abiertos.txt` existe y no está vacío.
- [ ] `puertos.txt` existe y no está vacío.
- [ ] `destino/` contiene los mismos archivos que `origen/` tras la sincronización.
- [ ] `destino/extra.txt` existe tras la segunda sincronización.
- [ ] `sync_log.txt` existe y no está vacío.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `lsof -p $$` lista archivos abiertos por la shell actual.
- `lsof -i -P -n` lista conexiones de red (requiere permisos para ver todos).
- `rsync -av origen/ destino/` sincroniza (la barra final de `origen/` copia el contenido).
- Comprueba disponibilidad con `command -v rsync`.
- Como fallback: `cp -r origen/. destino/`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

# 1. Diagnóstico con lsof
if command -v lsof >/dev/null 2>&1; then
  lsof -p $$ > abiertos.txt 2>/dev/null || echo "lsof sin permisos" > abiertos.txt
  lsof -i -P -n 2>/dev/null | head -20 > puertos.txt || echo "sin sockets visibles" > puertos.txt
else
  echo "lsof no disponible" > abiertos.txt
  echo "lsof no disponible" > puertos.txt
fi

# 2. Sincronización con rsync
mkdir -p destino
if command -v rsync >/dev/null 2>&1; then
  rsync -av origen/ destino/ >/dev/null 2>&1
  echo "archivo extra" > origen/extra.txt
  rsync -av origen/ destino/ > sync_log.txt 2>&1
else
  echo "rsync no disponible, usando cp" > sync_log.txt
  cp -r origen/. destino/
  echo "archivo extra" > origen/extra.txt
  cp -r origen/. destino/
fi
```

</details>
