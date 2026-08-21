# Ejercicio 04 — Paralelismo con `xargs`

- **Nivel:** 5/5
- **Tema:** `xargs -P`, `-n`, `-I`, paralelismo, medición de tiempos con `time`
- **Tiempo estimado:** 40 min

## Enunciado

`setup.sh` crea una carpeta `img/` con 12 archivos de texto simulando imágenes (`foto-01.txt` ... `foto-12.txt`), cada uno de unos pocos KB.

Escribe `solucion.sh` que:

1. Procese cada archivo de `img/` aplicándole un comando de transformación. Para simular trabajo, usa un helper `procesar.sh` (que tú también creas) que duerme 1 segundo y escribe un resumen en `procesados/<nombre>.out`.

2. **Versión secuencial:** procesa los 12 archivos uno a uno y mide el tiempo total con `time`. Guarda la salida en `tiempo_secuencial.txt`.

3. **Versión paralela:** usa `xargs -P4 -n1 -I{}` para procesar 4 archivos en paralelo y mide el tiempo total. Guarda la salida en `tiempo_paralelo.txt`.

4. Genera `comparacion.txt` con dos líneas:
   - `Secuencial: <aprox>` 
   - `Paralelo: <aprox>`
   - `Aceleracion: <factor>` (cociente)

> El objetivo es comprobar que la versión paralela con `xargs -P4` es unas 3-4 veces más rápida que la secuencial.

## Requisitos

- [ ] Existe `procesar.sh` y es ejecutable.
- [ ] Se crean 12 archivos `.out` en `procesados/`.
- [ ] `tiempo_secuencial.txt` existe y no está vacío.
- [ ] `tiempo_paralelo.txt` existe y no está vacío.
- [ ] `comparacion.txt` contiene `Secuencial:` y `Paralelo:`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Crea `procesar.sh` con `#!/usr/bin/env bash`, `sleep 1`, `mkdir -p procesados`, `cp "$1" "procesados/$(basename "$1").out"`.
- Secuencial: `for f in img/*; do ./procesar.sh "$f"; done`.
- Paralelo: `ls img/* | xargs -P4 -n1 -I{} ./procesar.sh {}`.
- Mide con `({ comando; } > /dev/null 2>&1) 2> tiempo.txt` o usa `date +%s%N` antes y después.
- Para extraer el tiempo real de `time`, redirige stderr: `{ time ...; } 2> tiempo.txt`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

# Helper de procesamiento
cat > procesar.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
archivo="$1"
sleep 1
mkdir -p procesados
cp "$archivo" "procesados/$(basename "$archivo").out"
EOF
chmod +x procesar.sh

mkdir -p procesados

# Versión secuencial
t1=$(date +%s)
for f in img/*; do
  ./procesar.sh "$f"
done
t2=$(date +%s)
sec=$((t2 - t1))
echo "Segundos: $sec" > tiempo_secuencial.txt

# Limpiar para versión paralela
rm -rf procesados
mkdir -p procesados

# Versión paralela
t1=$(date +%s)
ls img/* | xargs -P4 -n1 -I{} ./procesar.sh {}
t2=$(date +%s)
par=$((t2 - t1))
echo "Segundos: $par" > tiempo_paralelo.txt

# Comparación
acel=$(awk "BEGIN {printf \"%.2f\", $sec / $par}")
{
  echo "Secuencial: ${sec}s"
  echo "Paralelo: ${par}s"
  echo "Aceleracion: ${acel}x"
} > comparacion.txt
```

</details>
