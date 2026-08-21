#!/usr/bin/env bash
set -euo pipefail

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

t1=$(date +%s)
for f in img/*; do
  ./procesar.sh "$f"
done
t2=$(date +%s)
sec=$((t2 - t1))
echo "Segundos: $sec" > tiempo_secuencial.txt

rm -rf procesados
mkdir -p procesados

t1=$(date +%s)
ls img/* | xargs -P4 -n1 -I{} ./procesar.sh {}
t2=$(date +%s)
par=$((t2 - t1))
echo "Segundos: $par" > tiempo_paralelo.txt

acel=$(awk "BEGIN {printf \"%.2f\", $sec / $par}")
{
  echo "Secuencial: ${sec}s"
  echo "Paralelo: ${par}s"
  echo "Aceleracion: ${acel}x"
} > comparacion.txt
