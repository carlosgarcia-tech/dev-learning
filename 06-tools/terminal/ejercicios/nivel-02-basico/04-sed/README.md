# 04 — sed

## Enunciado

Usa sed para sustituir texto.

## Requisitos

1. Crea `solucion/config.txt` con `port=3000`.
2. Usa `sed` para cambiar `3000` por `8080` y guarda el resultado en `config-nueva.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
echo "port=3000" > solucion/config.txt
sed 's/3000/8080/' solucion/config.txt > solucion/config-nueva.txt
```

</details>
