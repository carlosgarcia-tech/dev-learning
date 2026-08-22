# 06 — set -euo pipefail

## Enunciado

Haz un script robusto.

## Requisitos

1. Crea `solucion/robusto.sh` con `set -euo pipefail` al inicio.
2. El script debe definir una función y usar una variable local.
3. Explica en `respuesta.txt` qué hace cada flag de `set -euo pipefail`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
set -euo pipefail

mi_funcion() {
  local x=10
  echo $x
}
mi_funcion
```

`respuesta.txt`:
```
-e: falla si cualquier comando falla.
-u: falla si se usa una variable no definida.
-o pipefail: un pipe falla si cualquier comando del pipe falla.
```

</details>
