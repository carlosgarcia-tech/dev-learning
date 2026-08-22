# 02 — Condicional if

## Enunciado

Crea un script con un condicional.

## Requisitos

1. Crea `solucion/par.sh` que reciba un número como argumento.
2. Imprima "par" si es par, "impar" si no.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
if [ $(($1 % 2)) -eq 0 ]; then
  echo "par"
else
  echo "impar"
fi
```

</details>
