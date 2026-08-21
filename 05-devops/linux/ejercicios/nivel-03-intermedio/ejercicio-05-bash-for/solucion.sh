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
