# Ejercicio 05 — Script Bash con `for`

- **Nivel:** 3/5
- **Tema:** bucle `for`, `seq`, `range`, acumuladores, argumentos `$@`
- **Tiempo estimado:** 25 min

## Enunciado

Escribe un script `solucion.sh` que acepte una lista de números como argumentos y produzca varios informes:

- `./solucion.sh 5 10 3 8` → imprime y genera archivos.

El script debe:

1. Recorrer los argumentos con `for n in "$@"` y, para cada uno, imprimir `n: <numero>`.
2. Calcular la **suma** de todos los argumentos y guardarla en `suma.txt`.
3. Contar **cuántos** argumentos son **pares** (usando `(( n % 2 == 0 ))`) y guardar el número en `pares.txt`.
4. Encontrar el **máximo** y guardarlo en `maximo.txt`.
5. Generar un archivo `tabla.txt` con la tabla de multiplicar del **primer** argumento (del 1 al 10), una línea por producto: `N x 1 = ...`.

## Requisitos

- [ ] Al ejecutar `./solucion.sh 5 10 3 8`, se imprimen 4 líneas `n: <numero>`.
- [ ] `suma.txt` contiene `26` (5+10+3+8).
- [ ] `pares.txt` contiene `2` (10 y 8 son pares).
- [ ] `maximo.txt` contiene `10`.
- [ ] `tabla.txt` tiene 10 líneas y la primera es `5 x 1 = 5`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `for n in "$@"; do ... done` recorre los argumentos.
- Acumula con `suma=$((suma + n))`.
- Comprueba paridad con `(( n % 2 == 0 ))` dentro de un `if`.
- El máximo se inicializa al primer argumento y se compara con cada uno.
- La tabla: `for i in $(seq 1 10); do echo "$n x $i = $((n*i))"; done`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Uso: solucion.sh <num1> [num2] ..."
  exit 1
fi

suma=0
pares=0
maximo="$1"

for n in "$@"; do
  echo "n: $n"
  suma=$((suma + n))
  if (( n % 2 == 0 )); then
    pares=$((pares + 1))
  fi
  if (( n > maximo )); then
    maximo=$n
  fi
done

echo "$suma" > suma.txt
echo "$pares" > pares.txt
echo "$maximo" > maximo.txt

base="$1"
for i in $(seq 1 10); do
  echo "$base x $i = $((base * i))"
done > tabla.txt
```

</details>
