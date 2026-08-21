# Ejercicios — MongoDB

Cada ejercicio incluye un `README.md` con enunciado, requisitos, pistas plegables y solución plegable, además de un `test.sh` que valida el ejercicio.

## Cómo validar un ejercicio

```bash
cd nivel-01-fundamentos/ejercicio-01-insert-y-find
bash test.sh
```

- Si `mongosh` y un servidor MongoDB están disponibles, `test.sh` ejecuta el `setup` + la `solución` contra la base `ejercicios_db`.
- Si no, valida la sintaxis JS de la solución con `node --check`.
- Salida: `OK Tests pasaron` (exit 0) o `FAIL Tests fallaron` (exit 1).

## Niveles

| Nivel | Qué cubre | Ejercicios | Estado |
|---|---|---|---|
| [01 — Fundamentos](nivel-01-fundamentos/) | CRUD básico: insert, find, update, delete, sort, limit | 6 | ⬜ |
| [02 — Básico](nivel-02-basico/) | Operadores de comparación, lógicos, regex, arrays, embebidos, agregados | 6 | ⬜ |
| [03 — Intermedio](nivel-03-intermedio/) | Aggregation pipeline: `$group`, `$project`, `$lookup`, `$unwind`, condicionales | 6 | ⬜ |
| [04 — Avanzado](nivel-04-avanzado/) | Índices, texto, geoespacial, upsert, validación de esquemas | 6 | ⬜ |
| [05 — Experto](nivel-05-experto/) | Modelado, transacciones, agregación avanzada, change streams, Atlas Search | 6 | ⬜ |
| [Proyectos](proyectos/) | Retos integradores | 1 | ⬜ |

## Listado completo

### Nivel 01 — Fundamentos

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Insert y Find](nivel-01-fundamentos/ejercicio-01-insert-y-find/) | `insertOne`, `insertMany`, `find`, `countDocuments` |
| 02 | [Find con Filtros](nivel-01-fundamentos/ejercicio-02-find-con-filtros/) | `$ne`, `$gte`, filtros múltiples |
| 03 | [Proyección](nivel-01-fundamentos/ejercicio-03-proyeccion/) | Proyección inclusiva y exclusiva |
| 04 | [Update](nivel-01-fundamentos/ejercicio-04-update/) | `$set`, `$inc`, `$unset` |
| 05 | [Delete](nivel-01-fundamentos/ejercicio-05-delete/) | `deleteOne`, `deleteMany`, `drop` |
| 06 | [Orden y Limit](nivel-01-fundamentos/ejercicio-06-orden-y-limit/) | `sort`, `limit`, `skip` |

### Nivel 02 — Básico

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Comparación](nivel-02-basico/ejercicio-01-comparacion/) | `$gt`, `$gte`, `$lte`, `$in`, `$nin` |
| 02 | [Lógicos](nivel-02-basico/ejercicio-02-logicos/) | `$and`, `$or`, `$not`, `$nor` |
| 03 | [Regex y Existe](nivel-02-basico/ejercicio-03-regex-y-existe/) | `$regex`, `$exists`, `$type` |
| 04 | [Arrays](nivel-02-basico/ejercicio-04-arrays/) | `$all`, `$size`, `$elemMatch` |
| 05 | [Campos Embebidos](nivel-02-basico/ejercicio-05-campos-embebidos/) | Dot notation |
| 06 | [Agregados Básicos](nivel-02-basico/ejercicio-06-agregados-basicos/) | `countDocuments`, `distinct` |

### Nivel 03 — Intermedio

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Group y Sum](nivel-03-intermedio/ejercicio-01-group-y-sum/) | `$group`, `$sum`, `$count`, `$avg` |
| 02 | [Project y Campos](nivel-03-intermedio/ejercicio-02-project-y-campos/) | `$project`, `$addFields`, `$round` |
| 03 | [Lookup (Join)](nivel-03-intermedio/ejercicio-03-lookup-join/) | `$lookup`, `$unwind` |
| 04 | [Unwind](nivel-03-intermedio/ejercicio-04-unwind/) | `$unwind`, `$group` |
| 05 | [Sort, Limit y Skip](nivel-03-intermedio/ejercicio-05-sort-limit-skip/) | `$sort`, `$limit`, `$skip` |
| 06 | [Condicionales](nivel-03-intermedio/ejercicio-06-condicionales/) | `$cond`, `$ifNull` |

### Nivel 04 — Avanzado

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Indices Básicos](nivel-04-avanzado/ejercicio-01-indices-basicos/) | `createIndex`, `getIndexes`, `dropIndex` |
| 02 | [Indices Compuestos](nivel-04-avanzado/ejercicio-02-indices-compuestos/) | Índices compuestos, `explain` |
| 03 | [Indices de Texto](nivel-04-avanzado/ejercicio-03-indices-texto/) | `$text`, `$search`, `textScore` |
| 04 | [Geospatial](nivel-04-avanzado/ejercicio-04-geospatial/) | `2dsphere`, `$geoNear`, `$geoWithin` |
| 05 | [Upsert y Arrays](nivel-04-avanzado/ejercicio-05-upsert-y-arrays/) | `upsert`, `$push`, `$pull`, `$addToSet` |
| 06 | [Validaciones](nivel-04-avanzado/ejercicio-06-validaciones/) | `$jsonSchema`, validación de documentos |

### Nivel 05 — Experto

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Modelado Embebido](nivel-05-experto/ejercicio-01-modelado-embebido/) | Modelado embebido, dot notation |
| 02 | [Transacciones](nivel-05-experto/ejercicio-02-transacciones/) | Sesiones, commit/abort *(requiere replica set)* |
| 03 | [Agregación Avanzada](nivel-05-experto/ejercicio-03-agregacion-avanzada/) | `$bucket`, `$facet` |
| 04 | [Change Streams](nivel-05-experto/ejercicio-04-change-streams/) | `watch()`, `operationType` *(requiere replica set)* |
| 05 | [Atlas Search](nivel-05-experto/ejercicio-05-atlas-search/) | `$text`, `$search`, exclusión |
| 06 | [Mini Proyecto](nivel-05-experto/ejercicio-06-mini-proyecto/) | `$group`, `$unwind`, `$lookup`, `$substr` |

### Proyectos

| Proyecto | Descripción | Estado |
|---|---|---|
| [Blog NoSQL con MongoDB](proyectos/) | Proyecto integrador: blog con usuarios, posts, comentarios, tags, agregaciones, índices, validación y change streams | ⬜ |

## Notas

- Los ejercicios del nivel 05 marcados con _requiere replica set_ necesitan un MongoDB configurado como replica set para transacciones y change streams.
- Cada carpeta conserva los archivos originales con prefijo (`ejercicio-XX-...-setup.js`, `*-solucion.js`, `*-expected.txt`); el `test.sh` los detecta automáticamente.
