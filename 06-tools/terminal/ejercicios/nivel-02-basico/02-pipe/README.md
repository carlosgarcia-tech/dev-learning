# 02 — Pipe

## Enunciado

Usa pipes para encadenar comandos.

## Requisitos

1. Crea `solucion/resultado.txt` con el resultado de: `seq 1 100 | grep "5" | wc -l`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
seq 1 100 | grep "5" | wc -l > solucion/resultado.txt
```

</details>
