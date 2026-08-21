# Nivel 5 — Experto

Modelado de datos, transacciones, agregaciones avanzadas, change streams, búsqueda de texto y un mini proyecto integrador. Todos los ejercicios usan datos de ejemplo deterministas y verifican su salida con un contenedor efímero de MongoDB (`podman` + `mongo:7`).

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Modelado Embebido](ejercicio-01-modelado-embebido/) | documentos embebidos, dot notation, `$push` |
| 02 | [Transacciones](ejercicio-02-transacciones/) | sessions, `startTransaction`, `commitTransaction`, `abortTransaction` |
| 03 | [Agregación Avanzada](ejercicio-03-agregacion-avanzada/) | `$bucket`, `$facet`, `$group` con `$push`, `$sort` |
| 04 | [Change Streams](ejercicio-04-change-streams/) | `watch()`, `operationType`, `cursor.next()`, `cs.close()` |
| 05 | [Atlas Search](ejercicio-05-atlas-search/) | `createIndex`, `$text`, `$search`, `$meta textScore`, exclusión y `$match` |
| 06 | [Mini Proyecto](ejercicio-06-mini-proyecto/) | `$group`, `$unwind`, `$lookup`, `$substr`, `$sort`, `$limit` |

## Cómo ejecutar un ejercicio

```bash
cd <carpeta-del-ejercicio>
bash ejercicio-0N-slug-test.sh   # requiere podman (levanta un contenedor efímero de mongo:7)
```

Cada carpeta sigue el mismo esquema de ficheros con prefijo `ejercicio-0N-slug`:

- `ejercicio-0N-slug.md` — enunciado, pistas y solución.
- `ejercicio-0N-slug-setup.js` — carga los datos de ejemplo (borra la colección con `drop()` e inserta datos deterministas con `insertMany`).
- `ejercicio-0N-slug-solucion.js` — la solución de referencia (salida determinista: proyección `_id: 0`, `sort()` estable y `printjson`).
- `ejercicio-0N-slug-expected.txt` — salida esperada, generada ejecutando la solución en un contenedor real.
- `ejercicio-0N-slug-test.sh` — aplica el setup, ejecuta la solución y compara la salida con `expected.txt`; imprime `OK` si coinciden.

## Aviso importante: replica set

Los ejercicios **02 (Transacciones)** y **04 (Change Streams)** requieren un **replica set** de MongoDB, porque tanto las transacciones como los change streams solo están disponibles en un clúster con replicación. Su `test.sh` gestiona esto automáticamente:

1. Arranca el contenedor con `mongod --replSet rs0 --bind_ip_all`.
2. Ejecuta `rs.initiate()` y espera (hasta ~30 s) a que el nodo alcance el estado `PRIMARY`.
3. Aplica el setup y ejecuta la solución con normalidad, comparando la salida con `expected.txt`.

El resto de ejercicios (01, 03, 05, 06) funcionan con un `mongod` standalone normal.

Los tests asumen la base `ejercicios_db` (se pasa como argumento a `mongosh`, sin `use`) y requieren podman con la imagen `docker.io/library/mongo:7` disponible localmente.
