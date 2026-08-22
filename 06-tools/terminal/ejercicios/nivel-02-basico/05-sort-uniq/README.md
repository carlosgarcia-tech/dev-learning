# 05 — sort y uniq

## Enunciado

Ordena y elimina duplicados.

## Requisitos

1. Crea `solucion/nombres.txt` con nombres repetidos.
2. Usa `sort | uniq -c | sort -rn` y guarda en `frecuencia.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
echo -e "Ada\nBob\nAda\nCarol\nBob\nAda" > solucion/nombres.txt
sort solucion/nombres.txt | uniq -c | sort -rn > solucion/frecuencia.txt
```

</details>
