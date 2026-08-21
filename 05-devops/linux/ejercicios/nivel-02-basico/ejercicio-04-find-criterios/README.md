# Ejercicio 04 — `find` con criterios

- **Nivel:** 2/5
- **Tema:** `find -type`, `-size`, `-mtime`, `-name`, `-empty`, `-exec`
- **Tiempo estimado:** 25 min

## Enunciado

`setup.sh` crea un directorio `archivos/` con:

- Varios `.log`, `.txt`, `.bak`
- Un archivo grande (`grande.log`, > 10 KB)
- Un archivo vacío (`vacio.txt`)
- Algunos archivos con antigüedad modificada distinta

Escribe `solucion.sh` que, desde `archivos/`, genere:

1. `por_tipo_dir.txt` — lista de directorios (`find . -type d`).
2. `por_tipo_archivo.txt` — lista de archivos regulares (`find . -type f`).
3. `por_nombre_bak.txt` — archivos con extensión `.bak` (`-name "*.bak"`).
4. `por_tamano.txt` — archivos mayores de 10 KB (`-size +10k`).
5. `vacios.txt` — archivos vacíos (`-empty`).
6. `ejecutar_chmod.txt` — resultado de `find . -name "*.sh" -exec chmod +x {} \;` (primero crea `script.sh` si hace falta) y luego lista sus permisos.

Para el punto 6, crea antes `script.sh` con `echo '#!/bin/bash' > script.sh`, aplícale `chmod` vía `find -exec` y guarda la salida de `find . -name "*.sh" -exec ls -l {} \;`.

## Requisitos

- [ ] `por_tipo_dir.txt` contiene `.`.
- [ ] `por_tipo_archivo.txt` contiene archivos regulares (no `.`).
- [ ] `por_nombre_bak.txt` contiene al menos un `.bak`.
- [ ] `por_tamano.txt` contiene `grande.log`.
- [ ] `vacios.txt` contiene `vacio.txt`.
- [ ] `script.sh` existe y tiene permiso de ejecución (`-rwx...` o `rwx`).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `find . -type d` lista directorios; `-type f` archivos regulares.
- `-name "*.bak"` filtra por extensión (¡usa comillas!).
- `-size +10k` busca mayores de 10 KB (k minúscula).
- `-empty` encuentra archivos vacíos.
- `find . -name "*.sh" -exec chmod +x {} \;` ejecuta un comando por cada coincidencia.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd archivos
find . -type d > por_tipo_dir.txt
find . -type f > por_tipo_archivo.txt
find . -name "*.bak" > por_nombre_bak.txt
find . -size +10k > por_tamano.txt
find . -empty > vacios.txt

echo '#!/bin/bash' > script.sh
find . -name "*.sh" -exec chmod +x {} \;
find . -name "*.sh" -exec ls -l {} \; > ejecutar_chmod.txt
```

</details>
