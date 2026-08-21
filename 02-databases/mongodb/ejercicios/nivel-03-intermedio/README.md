# Nivel 3 — Intermedio

Aggregation pipeline de MongoDB: agrupación y sumas, proyección y campos calculados, joins con `$lookup`, aplanado de arrays con `$unwind`, paginación con `$sort`/`$limit`/`$skip` y lógica condicional con `$cond`/`$ifNull`. Todos los ejercicios usan datos de ejemplo deterministas y verifican su salida con un contenedor efímero de MongoDB (`podman` + `mongo:7`).

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Group y Sum](ejercicio-01-group-y-sum/) | `$group`, `$sum`, `$count`, `$avg`, `$match`, `$sort` |
| 02 | [Project y Campos](ejercicio-02-project-y-campos/) | `$project`, `$addFields`, `$multiply`, `$round`, `$limit` |
| 03 | [Lookup (Join)](ejercicio-03-lookup-join/) | `$lookup`, `$unwind`, `$size`, `$match` |
| 04 | [Unwind](ejercicio-04-unwind/) | `$unwind`, `$group`, `$sum`, `$multiply` |
| 05 | [Sort, Limit y Skip](ejercicio-05-sort-limit-skip/) | `$sort`, `$limit`, `$skip`, `$project` |
| 06 | [Condicionales](ejercicio-06-condicionales/) | `$cond`, `$ifNull`, `$add`, `$sort` |

## Cómo ejecutar un ejercicio

```bash
cd <carpeta-del-ejercicio>
bash ejercicio-0N-slug-test.sh   # requiere podman (levanta un contenedor efímero de mongo:7)
```

Cada carpeta sigue el mismo esquema de ficheros con prefijo `ejercicio-0N-slug`:

- `ejercicio-0N-slug.md` — enunciado, pistas y solución.
- `ejercicio-0N-slug-setup.js` — carga los datos de ejemplo (borra la colección con `drop()` e inserta datos deterministas con `insertMany`).
- `ejercicio-0N-slug-solucion.js` — la solución de referencia usando el aggregation pipeline (salida determinista: `$sort` final, proyección `_id: 0` y `printjson`).
- `ejercicio-0N-slug-expected.txt` — salida esperada, generada ejecutando la solución en un contenedor real.
- `ejercicio-0N-slug-test.sh` — aplica el setup, ejecuta la solución y compara la salida con `expected.txt`; imprime `OK` si coinciden.

Los tests asumen la base `ejercicios_db` (se pasa como argumento a `mongosh`, sin `use`) y requieren podman con la imagen `docker.io/library/mongo:7` disponible localmente.