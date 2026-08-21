# Nivel 4 — Avanzado

Índices y rendimiento en MongoDB: índices básicos y compuestos, búsqueda de texto con `$text`, consultas geoespaciales con `2dsphere`, operadores de actualización sobre arrays (`upsert`, `$push`, `$pull`, `$addToSet`) y validación de esquemas con `$jsonSchema`. Todos los ejercicios usan datos de ejemplo deterministas y verifican su salida con un contenedor efímero de MongoDB (`podman` + `mongo:7`).

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Indices Básicos](ejercicio-01-indices-basicos/) | `createIndex`, `getIndexes`, `dropIndex`, dirección de índices |
| 02 | [Indices Compuestos](ejercicio-02-indices-compuestos/) | índices compuestos, `explain("executionStats")` |
| 03 | [Indices de Texto](ejercicio-03-indices-texto/) | `$text`, `$search`, `$meta textScore`, frase exacta, exclusión |
| 04 | [Geospatial](ejercicio-04-geospatial/) | `2dsphere`, `$geoNear`, `$geoWithin`, `$box`, `$centerSphere` |
| 05 | [Upsert y Arrays](ejercicio-05-upsert-y-arrays/) | `upsert`, `$push`, `$pull`, `$addToSet` |
| 06 | [Validaciones](ejercicio-06-validaciones/) | `createCollection` con `$jsonSchema`, errores de validación |

## Cómo ejecutar un ejercicio

```bash
cd <carpeta-del-ejercicio>
bash ejercicio-0N-slug-test.sh   # requiere podman (levanta un contenedor efímero de mongo:7)
```

Cada carpeta sigue el mismo esquema de ficheros con prefijo `ejercicio-0N-slug`:

- `ejercicio-0N-slug.md` — enunciado, pistas y solución.
- `ejercicio-0N-slug-setup.js` — carga los datos de ejemplo (borra la colección con `drop()` e inserta datos deterministas con `insertMany`).
- `ejercicio-0N-slug-solucion.js` — la solución de referencia (salida determinista: proyección `_id: 0`, `sort()` estable y `printjson`; los índices se imprimen por nombre y `explain` muestra solo campos estables como `nReturned`/`totalKeysExamined`/`totalDocsExamined`).
- `ejercicio-0N-slug-expected.txt` — salida esperada, generada ejecutando la solución en un contenedor real.
- `ejercicio-0N-slug-test.sh` — aplica el setup, ejecuta la solución y compara la salida con `expected.txt`; imprime `OK` si coinciden.

Los tests asumen la base `ejercicios_db` (se pasa como argumento a `mongosh`, sin `use`) y requieren podman con la imagen `docker.io/library/mongo:7` disponible localmente.