# 04 — Script de revisión de PR

## Enunciado

Crea un script que use opencode para revisar un PR.

## Requisitos

1. Crea `solucion/review.sh` que ejecute opencode para revisar los cambios del git diff.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/bin/bash
# review.sh
opencode run "Revisa los cambios de git diff main...HEAD. Identifica bugs, problemas de seguridad y mejoras. Genera un informe en Markdown." --auto
```

</details>
