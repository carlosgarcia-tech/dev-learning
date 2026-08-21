# Ejercicio 06 — Redirección y *pipes*

- **Nivel:** 2/5
- **Tema:** `>` `>>` `2>` `2>&1`, `|`, `tee`, `stdin`/`stdout`/`stderr`
- **Tiempo estimado:** 25 min

## Enunciado

`setup.sh` crea `numeros.txt` con 100 líneas (los números del 1 al 100).

Escribe `solucion.sh` que:

1. Cuente cuántas líneas tiene `numeros.txt` y guarde el resultado en `total_lineas.txt` (`wc -l < numeros.txt`).
2. Sume todos los números del archivo usando `awk` por *pipe*: `awk '{s+=$1} END {print s}' numeros.txt > suma.txt`. El resultado debe ser `5050` (suma 1..100).
3. Encadene `cat numeros.txt | grep -E "^[0-9]+$" | wc -l > pares.txt` (cuenta líneas que son solo dígitos).
4. Use `tee` para mostrar por pantalla **y** guardar en `log_tee.txt` el mensaje `Procesando datos...`.
5. Redirija `stdout` y `stderr` de un comando que falla (p. ej. `ls /no/existe`) a `errores_y_salida.txt` con `2>&1`.

## Requisitos

- [ ] `total_lineas.txt` contiene `100`.
- [ ] `suma.txt` contiene `5050`.
- [ ] `pares.txt` contiene `100`.
- [ ] `log_tee.txt` contiene `Procesando datos...`.
- [ ] `errores_y_salida.txt` contiene `No such file` o `no existe` (mensaje de error de `ls`).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `wc -l < numeros.txt > total_lineas.txt` cuenta líneas desde stdin.
- `awk '{s+=$1} END {print s}' numeros.txt > suma.txt` suma la 1ª columna.
- `echo "Procesando datos..." | tee log_tee.txt` escribe en archivo y pantalla.
- `ls /no/existe > errores_y_salida.txt 2>&1` junta stdout y stderr.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
wc -l < numeros.txt > total_lineas.txt
awk '{s+=$1} END {print s}' numeros.txt > suma.txt
cat numeros.txt | grep -E "^[0-9]+$" | wc -l > pares.txt
echo "Procesando datos..." | tee log_tee.txt
ls /no/existe > errores_y_salida.txt 2>&1 || true
```

> El `|| true` evita que `set -e` (en el test) aborte por el error de `ls`.

</details>
