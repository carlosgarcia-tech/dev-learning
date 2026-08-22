# 04 — cat, head, tail

## Enunciado

Visualiza el contenido de archivos.

## Requisitos

1. Crea `solucion/datos.txt` con 20 líneas numeradas.
2. Ejecuta `head -n 5` y guarda en `head.txt`.
3. Ejecuta `tail -n 5` y guarda en `tail.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
seq 1 20 > solucion/datos.txt
head -n 5 solucion/datos.txt > solucion/head.txt
tail -n 5 solucion/datos.txt > solucion/tail.txt
```

</details>
