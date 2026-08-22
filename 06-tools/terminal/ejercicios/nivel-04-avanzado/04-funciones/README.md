# 04 — Funciones

## Enunciado

Crea un script con funciones.

## Requisitos

1. Crea `solucion/func.sh` con una función `saludar` que reciba un nombre e imprima "Hola, $1".
2. Llama a la función con "Ada".

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
saludar() {
  echo "Hola, $1"
}
saludar "Ada"
```

</details>
