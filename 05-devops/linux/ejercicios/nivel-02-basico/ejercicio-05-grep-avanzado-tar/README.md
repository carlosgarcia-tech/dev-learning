# Ejercicio 05 — `grep` avanzado y compresión con `tar`

- **Nivel:** 2/5
- **Tema:** `grep -i`, `-v`, `-n`, `-c`, `-E`, `tar`, `gzip`, `tar.gz`
- **Tiempo estimado:** 25 min

## Enunciado

`setup.sh` crea un directorio `logs/` con dos archivos:

- `app.log` (con líneas que contienen `ERROR`, `WARNING`, `INFO` y `debug`)
- `server.log` (similar)

Escribe `solucion.sh` que, desde `logs/`:

1. `errores.txt` — líneas con `ERROR` (con `grep -n` para número de línea).
2. `sin_debug.txt` — líneas que **no** contienen `debug` (`grep -v`).
3. `cuenta_warning.txt` — número de líneas con `WARNING` (`grep -c`).
4. `errores_o_info.txt` — líneas con `ERROR` o `INFO` (`grep -E "ERROR|INFO"`).
5. Comprime **todos** los `.log` en `backup.tar.gz` con `tar czf`.
6. Lista el contenido de `backup.tar.gz` en `contenido_tar.txt` con `tar tzf`.

## Requisitos

- [ ] `errores.txt` contiene líneas con `ERROR` y números de línea.
- [ ] `sin_debug.txt` no contiene ninguna línea con `debug`.
- [ ] `cuenta_warning.txt` contiene un número (mayor que 0).
- [ ] `errores_o_info.txt` contiene líneas con `ERROR` o `INFO`.
- [ ] `backup.tar.gz` existe y contiene `app.log` y `server.log`.
- [ ] `contenido_tar.txt` lista los archivos del tar.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `grep -n "ERROR" app.log server.log > errores.txt` (varios archivos).
- `grep -iv "debug" *.log > sin_debug.txt` (insensible y a la inversa).
- `grep -c "WARNING" *.log > cuenta_warning.txt`.
- `grep -E "ERROR|INFO" *.log > errores_o_info.txt`.
- `tar czf backup.tar.gz *.log` comprime.
- `tar tzf backup.tar.gz > contenido_tar.txt` lista el contenido.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd logs
grep -n "ERROR" *.log > errores.txt
grep -iv "debug" *.log > sin_debug.txt
grep -c "WARNING" *.log > cuenta_warning.txt
grep -E "ERROR|INFO" *.log > errores_o_info.txt
tar czf backup.tar.gz *.log
tar tzf backup.tar.gz > contenido_tar.txt
```

</details>
