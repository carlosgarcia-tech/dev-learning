# Ejercicio 04 — Script Bash con `if`

- **Nivel:** 3/5
- **Tema:** `if`/`elif`/`else`, `test`/`[ ]`/`[[ ]]`, argumentos, exit codes
- **Tiempo estimado:** 25 min

## Enunciado

Escribe un script `solucion.sh` que clasifique una nota pasada como **argumento**:

- `./solucion.sh 95` → imprime `Excelente`
- `./solucion.sh 70` → imprime `Aprobado`
- `./solucion.sh 50` → imprime `Reprobado`
- `./solucion.sh abc` → imprime `Error: nota invalida` y sale con código `1`
- `./solucion.sh` (sin argumentos) → imprime `Uso: solucion.sh <nota>` y sale con código `2`

Escalas:

| Rango | Resultado |
|---|---|
| 90-100 | Excelente |
| 60-89 | Aprobado |
| 0-59 | Reprobado |

El script debe **imprimir solo una palabra** (`Excelente`/`Aprobado`/`Reprobado`) en los casos válidos.

## Requisitos

- [ ] `./solucion.sh 95` imprime `Excelente` y sale con código `0`.
- [ ] `./solucion.sh 70` imprime `Aprobado` y sale con código `0`.
- [ ] `./solucion.sh 50` imprime `Reprobado` y sale con código `0`.
- [ ] `./solucion.sh abc` imprime `Error: nota invalida` y sale con código `1`.
- [ ] `./solucion.sh` (sin args) imprime `Uso:` y sale con código `2`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Comprueba el número de argumentos con `[ $# -ne 1 ]`.
- Valida que `$1` sea numérico con `[[ $1 =~ ^[0-9]+$ ]]`.
- Compara enteros con `-ge`, `-lt`, etc. dentro de `[ ]`.
- Usa `exit 0`, `exit 1`, `exit 2` según el caso.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Uso: solucion.sh <nota>"
  exit 2
fi

nota="$1"
if ! [[ "$nota" =~ ^[0-9]+$ ]]; then
  echo "Error: nota invalida"
  exit 1
fi

if [ "$nota" -ge 90 ] && [ "$nota" -le 100 ]; then
  echo "Excelente"
elif [ "$nota" -ge 60 ] && [ "$nota" -le 89 ]; then
  echo "Aprobado"
elif [ "$nota" -ge 0 ] && [ "$nota" -le 59 ]; then
  echo "Reprobado"
else
  echo "Error: nota invalida"
  exit 1
fi
```

</details>
