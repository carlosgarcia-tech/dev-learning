# 03 — ls y permisos

## Enunciado

Lista archivos y entiende los permisos.

## Requisitos

1. Crea `solucion/script.sh` con un `echo`.
2. Dale permisos de ejecución con `chmod +x`.
3. Verifica que se puede ejecutar.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
echo '#!/bin/bash\necho Hola' > solucion/script.sh
chmod +x solucion/script.sh
./solucion/script.sh
```

</details>
