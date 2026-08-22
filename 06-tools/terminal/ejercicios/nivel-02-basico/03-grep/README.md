# 03 — grep

## Enunciado

Busca texto con grep.

## Requisitos

1. Crea `solucion/log.txt` con varias líneas (algunas con "ERROR").
2. Usa `grep "ERROR"` y guarda el resultado en `errores.txt`.
3. Cuenta cuántos errores hay y guárdalo en `conteo.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
echo -e "INFO: start\nERROR: not found\nINFO: done\nERROR: timeout" > solucion/log.txt
grep "ERROR" solucion/log.txt > solucion/errores.txt
grep -c "ERROR" solucion/log.txt > solucion/conteo.txt
```

</details>
