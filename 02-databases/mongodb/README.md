# MongoDB

> Guías de estudio + ejercicios por niveles y un proyecto final integrador.

## Cómo usar este tema

1. Lee las guías en orden (`01` → `05`).
2. Practica con los ejercicios de cada nivel (6 ejercicios por nivel, 30 en total).
3. Cada ejercicio se valida con `bash test.sh` dentro de su carpeta.
4. Termina con el [proyecto final](ejercicios/proyectos/): un blog NoSQL completo.

## Requisitos

- `mongosh` (MongoDB Shell) conectado a un servidor MongoDB local, **o** `node` para validar la sintaxis de las soluciones.
- Opcional: `podman` o `docker` para levantar MongoDB efímero.

> Los `test.sh` de los ejercicios detectan automáticamente si `mongosh` + servidor están disponibles y ejecutan el setup + la solución; en caso contrario validan la sintaxis JS con `node --check`.

## Guías

| # | Guía | Tema principal |
|---|---|---|
| 01 | [Fundamentos de MongoDB](01-fundamentos.md) | Documentos, BSON, CRUD básico (`insert`, `find`, `update`, `delete`), tipos, `_id` |
| 02 | [Operadores de consulta](02-operadores-de-consulta.md) | `$gt`, `$in`, `$and`, `$or`, `$regex`, `$exists`, `$elemMatch`, dot notation |
| 03 | [Agregación](03-agregacion.md) | `$match`, `$group`, `$project`, `$lookup`, `$unwind`, `$sort`, `$limit` |
| 04 | [Índices y rendimiento](04-indices-y-rendimiento.md) | `createIndex`, índices compuestos, `explain`, texto, `2dsphere` |
| 05 | [Modelado y producción](05-modelado-y-produccion.md) | Embebido vs referencias, patrones, ACID, replica sets, sharding, change streams, seguridad |

## Ejercicios por nivel

| Nivel | Qué cubre | Ejercicios | Estado |
|---|---|---|---|
| [01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | CRUD básico: insert, find, update, delete, sort, limit | 6 | ⬜ |
| [02 — Básico](ejercicios/nivel-02-basico/) | Operadores de comparación, lógicos, regex, arrays, embebidos, agregados | 6 | ⬜ |
| [03 — Intermedio](ejercicios/nivel-03-intermedio/) | Aggregation pipeline: `$group`, `$project`, `$lookup`, `$unwind`, condicionales | 6 | ⬜ |
| [04 — Avanzado](ejercicios/nivel-04-avanzado/) | Índices, texto, geoespacial, upsert, validación de esquemas | 6 | ⬜ |
| [05 — Experto](ejercicios/nivel-05-experto/) | Modelado, transacciones, agregación avanzada, change streams, Atlas Search | 6 | ⬜ |
| [Proyectos](ejercicios/proyectos/) | Proyecto final integrador: Blog NoSQL | 1 | ⬜ |

### Detalle de ejercicios

#### Nivel 01 — Fundamentos

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Insert y Find](ejercicios/nivel-01-fundamentos/ejercicio-01-insert-y-find/) | `insertOne`, `insertMany`, `find`, `countDocuments` |
| 02 | [Find con Filtros](ejercicios/nivel-01-fundamentos/ejercicio-02-find-con-filtros/) | `$ne`, `$gte`, filtros múltiples |
| 03 | [Proyección](ejercicios/nivel-01-fundamentos/ejercicio-03-proyeccion/) | Proyección inclusiva y exclusiva |
| 04 | [Update](ejercicios/nivel-01-fundamentos/ejercicio-04-update/) | `updateOne`, `updateMany`, `$set`, `$inc`, `$unset` |
| 05 | [Delete](ejercicios/nivel-01-fundamentos/ejercicio-05-delete/) | `deleteOne`, `deleteMany`, `drop` |
| 06 | [Orden y Limit](ejercicios/nivel-01-fundamentos/ejercicio-06-orden-y-limit/) | `sort`, `limit`, `skip`, `findOne` |

#### Nivel 02 — Básico

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Comparación](ejercicios/nivel-02-basico/ejercicio-01-comparacion/) | `$gt`, `$gte`, `$lte`, `$in`, `$nin` |
| 02 | [Lógicos](ejercicios/nivel-02-basico/ejercicio-02-logicos/) | `$and`, `$or`, `$not`, `$nor` |
| 03 | [Regex y Existe](ejercicios/nivel-02-basico/ejercicio-03-regex-y-existe/) | `$regex`, `$options`, `$exists`, `$type` |
| 04 | [Arrays](ejercicios/nivel-02-basico/ejercicio-04-arrays/) | Coincidencia exacta, `$all`, `$size`, `$elemMatch` |
| 05 | [Campos Embebidos](ejercicios/nivel-02-basico/ejercicio-05-campos-embebidos/) | Dot notation, filtros y proyección sobre subcampos |
| 06 | [Agregados Básicos](ejercicios/nivel-02-basico/ejercicio-06-agregados-basicos/) | `countDocuments` y `distinct` |

#### Nivel 03 — Intermedio

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Group y Sum](ejercicios/nivel-03-intermedio/ejercicio-01-group-y-sum/) | `$group`, `$sum`, `$count`, `$avg`, `$match` |
| 02 | [Project y Campos](ejercicios/nivel-03-intermedio/ejercicio-02-project-y-campos/) | `$project`, `$addFields`, `$multiply`, `$round` |
| 03 | [Lookup (Join)](ejercicios/nivel-03-intermedio/ejercicio-03-lookup-join/) | `$lookup`, `$unwind`, `$size` |
| 04 | [Unwind](ejercicios/nivel-03-intermedio/ejercicio-04-unwind/) | `$unwind`, `$group`, `$multiply` |
| 05 | [Sort, Limit y Skip](ejercicios/nivel-03-intermedio/ejercicio-05-sort-limit-skip/) | `$sort`, `$limit`, `$skip` |
| 06 | [Condicionales](ejercicios/nivel-03-intermedio/ejercicio-06-condicionales/) | `$cond`, `$ifNull`, `$add` |

#### Nivel 04 — Avanzado

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Indices Básicos](ejercicios/nivel-04-avanzado/ejercicio-01-indices-basicos/) | `createIndex`, `getIndexes`, `dropIndex` |
| 02 | [Indices Compuestos](ejercicios/nivel-04-avanzado/ejercicio-02-indices-compuestos/) | Índices compuestos, `explain("executionStats")` |
| 03 | [Indices de Texto](ejercicios/nivel-04-avanzado/ejercicio-03-indices-texto/) | `$text`, `$search`, `$meta textScore` |
| 04 | [Geospatial](ejercicios/nivel-04-avanzado/ejercicio-04-geospatial/) | `2dsphere`, `$geoNear`, `$geoWithin`, `$box` |
| 05 | [Upsert y Arrays](ejercicios/nivel-04-avanzado/ejercicio-05-upsert-y-arrays/) | `upsert`, `$push`, `$pull`, `$addToSet` |
| 06 | [Validaciones](ejercicios/nivel-04-avanzado/ejercicio-06-validaciones/) | `createCollection`, `$jsonSchema` |

#### Nivel 05 — Experto

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Modelado Embebido](ejercicios/nivel-05-experto/ejercicio-01-modelado-embebido/) | Modelado embebido, dot notation, arrays |
| 02 | [Transacciones](ejercicios/nivel-05-experto/ejercicio-02-transacciones/) | Sesiones, `commitTransaction`, `abortTransaction` |
| 03 | [Agregación Avanzada](ejercicios/nivel-05-experto/ejercicio-03-agregacion-avanzada/) | `$bucket`, `$facet`, `$push` |
| 04 | [Change Streams](ejercicios/nivel-05-experto/ejercicio-04-change-streams/) | `watch()`, `operationType`, `cursor.next()` |
| 05 | [Atlas Search](ejercicios/nivel-05-experto/ejercicio-05-atlas-search/) | `$text`, `$search`, `textScore`, exclusión |
| 06 | [Mini Proyecto](ejercicios/nivel-05-experto/ejercicio-06-mini-proyecto/) | `$group`, `$unwind`, `$lookup`, `$substr` |

## Proyecto final

| Proyecto | Descripción | Estado |
|---|---|---|
| [Blog NoSQL con MongoDB](ejercicios/proyectos/) | Blog con usuarios, posts, comentarios, tags, agregaciones, índices, validación y change streams | ⬜ |
