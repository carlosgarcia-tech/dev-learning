# 05 — Exit codes

## Enunciado

Usa exit codes en un script.

## Requisitos

1. Crea `solucion/check.sh` que reciba un archivo como argumento.
2. Si el archivo existe, imprime "OK" y sale con código 0.
3. Si no existe, imprime "ERROR" y sale con código 1.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
if [ -f "$1" ]; then
  echo "OK"
  exit 0
else
  echo "ERROR"
  exit 1
fi
```

</details>
