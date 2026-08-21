# 03 — Agregación (aggregation pipeline)

## Objetivos

- [ ] Comprender qué es el *aggregation framework* y cuándo usarlo frente a `find`
- [ ] Conocer el *pipeline* como secuencia de etapas (`$match`, `$group`, `$project`, `$sort`, ...)
- [ ] Agrupar con `$group`: la clave `_id` y los acumuladores `$sum`, `$count`, `$avg`, `$min`, `$max`, `$first`, `$last`, `$push`
- [ ] Filtrar documentos en el origen con `$match` (incluso como primer paso para ahorrar trabajo)
- [ ] Dar forma a la salida con `$project` y `$addFields`: renombrar, computar y ocultar campos
- [ ] Ordenar y paginar con `$sort`, `$limit` y `$skip`, y contar con `$count`
- [ ] Aplanar arrays con `$unwind` y volver a agrupar tras aplanar
- [ ] Combinar colecciones con `$lookup` (`localField`/`foreignField`), con y sin `$unwind`
- [ ] Clasificar rangos con `$bucket` y ejecutar sub-pipelines en paralelo con `$facet`
- [ ] Evaluar lógica condicional con `$cond`, `$ifNull` y `$switch`
- [ ] Producir salida determinista: terminar con `$sort`, proyectar `_id: 0` y renombrar claves de grupo
- [ ] Usar las mismas colecciones de ejemplo de los ejercicios (`ventas`, `libros`, `autores`)

## Apuntes

### ¿Qué es la agregación?

El **aggregation framework** procesa documentos en **etapas** (stages) encadenadas: la salida de una etapa es la entrada de la siguiente. Cada etapa transforma un *stream* de documentos hasta obtener el resultado final.

```
ventas ─► [$match] ─► [$group] ─► [$sort] ─► [$project] ─► resultado
```

En `mongosh` se invoca con `db.<coleccion>.aggregate([ ...etapas ])`, pasando **un array** de etapas:

```js
db.ventas.aggregate([
  { $match: { ciudad: "madrid" } },
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
  { $sort: { total: -1 } }
]);
```

**¿Cuándo usar agregación y cuándo `find`?**

| Situación | Herramienta |
|---|---|
| Traer documentos crudos, con filtro, proyección y orden | `find()` |
| Contar coincidencias simples | `countDocuments()` |
| **Resumir**, agrupar, calcular totales o estadísticas | `aggregate([$group, ...])` |
| **Unir** dos colecciones | `aggregate([$lookup])` |
| Aplanar arrays y transformar el resultado por fila | `aggregate([$unwind, $project])` |
| Combinar varias agregaciones en un solo recorrido | `aggregate([$facet])` |

> 💡 Regla práctica: si solo necesitas filtrar/ordenar/proyectar, `find` es suficiente y más rápido. El *pipeline* brilla cuando hay **cálculo por grupo**, **uniones** o **transformaciones** que `find` no puede expresar.

### Etapas principales de un vistazo

| Etapa | Función |
|---|---|
| `$match` | Filtra documentos (equivale al filtro de `find`) |
| `$group` | Agrupa por una clave `_id` y acumula valores |
| `$project` | Selecciona, renombra, crea o elimina campos |
| `$addFields` | Añade o sobrescribe campos sin descartar los demás |
| `$sort` | Ordena los documentos |
| `$limit` / `$skip` | Pagina: toma N / salta N |
| `$count` | Cuenta los documentos de la etapa anterior |
| `$unwind` | Despliega un array en un documento por elemento |
| `$lookup` | Une con otra colección (`localField`/`foreignField`) |
| `$bucket` | Clasifica documentos en rangos |
| `$facet` | Ejecuta varios sub-pipelines sobre la misma entrada |

> ⚠️ El orden de las etapas importa: `$match` al principio reduce el trabajo de las siguientes; `$limit` después de `$sort` no paga el orden de todo el conjunto si hay índice. Piensa siempre qué etapa filtra/reduce antes.

### La colección de ejemplo `ventas`

Para todos los ejemplos usaremos una colección pequeña e idéntica a la de los ejercicios:

```js
db.ventas.drop();
db.ventas.insertMany([
  { vendedor: "ana",   importe: 120, ciudad: "madrid" },
  { vendedor: "ana",   importe: 80,  ciudad: "barcelona" },
  { vendedor: "luis",  importe: 250, ciudad: "madrid" },
  { vendedor: "carla", importe: 300, ciudad: "valencia" },
  { vendedor: "luis",  importe: 150, ciudad: "barcelona" },
  { vendedor: "ana",   importe: 200, ciudad: "valencia" },
  { vendedor: "carla", importe: 90,  ciudad: "madrid" },
  { vendedor: "luis",  importe: 175, ciudad: "valencia" },
  { vendedor: "marta", importe: 110, ciudad: "barcelona" },
  { vendedor: "marta", importe: 65,  ciudad: "madrid" }
]);
```

### `$match`: filtrar al inicio

Filtra documentos antes de cualquier cálculo. Usa la misma sintaxis de filtro que `find` (`$gte`, `$in`, `$or`, ...):

```js
db.ventas.aggregate([
  { $match: { ciudad: "madrid" } },
  { $sort: { importe: -1 } }
]);
```

### `$group`: agrupar y acumular

`$group` agrupa por la clave `_id`. Para referenciar un campo se usa el prefijo `$` (`"$vendedor"`). Las demás salidas son **acumuladores** que se calculan por grupo.

```js
db.ventas.aggregate([
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } }
]);
```

**Acumuladores más usados:**

| Acumulador | Efecto |
|---|---|
| `$sum: "$campo"` | Suma los valores del campo |
| `$sum: 1` | Cuenta documentos del grupo (equivalente a `$count`) |
| `$count: {}` | Cuenta los documentos del grupo |
| `$avg: "$campo"` | Promedio |
| `$min` / `$max` | Valor mínimo / máximo |
| `$first` / `$last` | Primer / último documento que llega (requiere orden previo) |
| `$push: "$campo"` | Array con todos los valores |

```js
db.ventas.aggregate([
  {
    $group: {
      _id: "$vendedor",
      total: { $sum: "$importe" },
      promedio: { $avg: "$importe" },
      ventas: { $count: {} },
      masCara: { $max: "$importe" },
      importes: { $push: "$importe" }
    }
  }
]);
```

> 💡 **Sin `_id` no hay grupo**: `{ $group: { _id: null, ... } }` agrupa **todos** los documentos en un solo grupo. Es la forma de calcular totales globales.

### `$project` y `$addFields`: dar forma a la salida

`$project` selecciona campos (con `1`/`0`), los **renombra** y crea **campos calculados** con expresiones. Al contrario que en la proyección de `find`, aquí **sí** se pueden mezclar inclusiones, exclusiones y expresiones, y se pueden usar funciones sobre los campos.

```js
db.ventas.aggregate([
  { $project: { vendedor: 1, importe: 1, conIva: { $multiply: ["$importe", 1.21] } } }
]);
```

Operadores aritméticos (`$add`, `$subtract`, `$multiply`, `$divide`) reciben un **array de operandos**; `$round` recibe `[valor, decimales]`:

```js
db.ventas.aggregate([
  {
    $project: {
      _id: 0,
      vendedor: "$vendedor",
      importe: 1,
      impuesto: { $round: [{ $multiply: ["$importe", 0.21] }, 2] },
      total: { $add: ["$importe", { $multiply: ["$importe", 0.21] }] },
      etiqueta: { $concat: ["Venta de ", "$vendedor", " en ", "$ciudad"] }
    }
  }
]);
```

- Renombrar se consigue proyectando el campo con el nombre nuevo: `nuevoNombre: "$campoViejo"`.
- `$addFields` hace lo mismo que `$project` pero **conserva todos los campos**; es ideal para añadir campos temporales sin armar una lista de inclusiones:

```js
db.ventas.aggregate([
  { $addFields: { conIva: { $round: [{ $multiply: ["$importe", 1.21] }, 2] } } },
  { $project: { _id: 0, vendedor: 1, importe: 1, conIva: 1 } }
]);
```

### `$sort`, `$limit`, `$skip`, `$count`

Igual que en `find`, `$sort` acepta `1` (ascendente) / `-1` (descendente) por campo. Son etapas independientes:

```js
db.ventas.aggregate([
  { $match: { ciudad: { $in: ["madrid", "barcelona"] } } },
  { $sort: { importe: -1 } },
  { $skip: 1 },
  { $limit: 2 }
]);
```

`$count` colapsa los documentos en **un solo documento** con el campo indicado:

```js
db.ventas.aggregate([
  { $match: { ciudad: "valencia" } },
  { $count: "totalVentas" }
]);
```

### `$unwind`: desplegar arrays

`$unwind` convierte cada elemento de un array en **un documento propio**, duplicando el resto de campos. Es la vía para agregar *por elemento* de un array.

```js
db.pedidos.insertMany([
  { _id: 1, cliente: "ana", items: [{ nombre: "Ratón", cantidad: 2, precio: 12 }, { nombre: "Teclado", cantidad: 1, precio: 25 }] },
  { _id: 2, cliente: "luis", items: [{ nombre: "Monitor", cantidad: 1, precio: 150 }] }
]);

db.pedidos.aggregate([
  { $unwind: "$items" }
]);
```

El resultado son 3 documentos (ana×2, luis×1) con el campo `items` siendo un **objeto** en lugar de un array. A partir de ahí se puede **volver a agrupar** para calcular totales por pedido o por cliente:

```js
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $addFields: { subtotal: { $multiply: ["$items.cantidad", "$items.precio"] } } },
  { $group: { _id: "$cliente", total: { $sum: "$subtotal" }, articulos: { $sum: "$items.cantidad" } } },
  { $sort: { total: -1 } }
]);
```

> 💡 Tras `$unwind`, los documentos cuyo array está vacío **desaparecen** (no hay elementos que emitir). Se puede evitar con la opción `{ $unwind: { path: "$items", preserveNullAndEmptyArrays: true } }`.

### `$lookup`: unir colecciones

`$lookup` combina documentos de la colección actual con los de otra mediante `localField`/`foreignField`. La salida añade un **campo array** con todos los documentos coincidentes.

```js
db.autores.drop();
db.libros.drop();
db.autores.insertMany([
  { _id: "a1", nombre: "Gabriel García Márquez", nacionalidad: "colombiana" },
  { _id: "a2", nombre: "Isabel Allende", nacionalidad: "chilena" },
  { _id: "a3", nombre: "Jorge Luis Borges", nacionalidad: "argentina" },
  { _id: "a4", nombre: "Julio Cortázar", nacionalidad: "argentina" }
]);
db.libros.insertMany([
  { _id: "l1", titulo: "Cien años de soledad", autor_id: "a1", anio: 1967 },
  { _id: "l2", titulo: "El amor en los tiempos del cólera", autor_id: "a1", anio: 1985 },
  { _id: "l3", titulo: "La casa de los espíritus", autor_id: "a2", anio: 1982 },
  { _id: "l4", titulo: "Inés del alma mía", autor_id: "a2", anio: 2006 },
  { _id: "l5", titulo: "Ficciones", autor_id: "a3", anio: 1944 },
  { _id: "l6", titulo: "Rayuela", autor_id: "a4", anio: 1963 }
]);

db.libros.aggregate([
  { $lookup: { from: "autores", localField: "autor_id", foreignField: "_id", as: "autor" } }
]);
```

Cada libro termina con un array `autor` (0 o 1 elemento). Para "desanidar" la unión se combina con `$unwind` y se limpia la salida:

```js
db.libros.aggregate([
  { $lookup: { from: "autores", localField: "autor_id", foreignField: "_id", as: "autor" } },
  { $unwind: "$autor" },
  { $project: { _id: 0, titulo: 1, anio: 1, autor: "$autor.nombre", nacionalidad: "$autor.nacionalidad" } },
  { $sort: { anio: 1 } }
]);
```

> ⚠️ La colección `from` y el campo `as` se escriben **sin** prefijo `$`; solo `localField` y `foreignField` van con `$`. El resultado de `$lookup` es siempre un **array**, aunque haya una sola coincidencia.

### `$bucket`: clasificar en rangos

`$bucket` clasifica los documentos según el valor de un campo en categorías definidas por `boundaries` (el último límite es abierto). Es útil para histogramas.

```js
db.ventas.aggregate([
  {
    $bucket: {
      groupBy: "$importe",
      boundaries: [0, 100, 200, 300, 400],
      default: "otros",
      output: { numVentas: { $sum: 1 }, totalImporte: { $sum: "$importe" } }
    }
  }
]);
```

### `$facet`: varios sub-pipelines en paralelo

`$facet` ejecuta **varios pipelines sobre la misma entrada** y devuelve un solo documento con un campo por faceta. Cada faceta procesa los mismos documentos de entrada de forma independiente.

```js
db.ventas.aggregate([
  {
    $facet: {
      totalPorVendedor: [
        { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
        { $sort: { total: -1 } }
      ],
      ventasPorCiudad: [
        { $group: { _id: "$ciudad", ventas: { $count: {} } } }
      ],
      importeMaximo: [
        { $group: { _id: null, max: { $max: "$importe" } } }
      ]
    }
  }
]);
```

### Condicionales: `$cond`, `$ifNull`, `$switch`

Se usan dentro de `$project`/`$addFields` para computar valores según condiciones.

| Operador | Sintaxis | Efecto |
|---|---|---|
| `$cond` | `{ $cond: [cond, verdadero, falso] }` | IF/THEN/ELSE ternario |
| `$ifNull` | `{ $ifNull: ["$campo", reemplazo] }` | Si el campo es `null`/inexistente, usa el reemplazo |
| `$switch` | `{ $switch: { branches: [{case, then}, ...], default } }` | CASE con varias ramas |

```js
db.ventas.aggregate([
  {
    $addFields: {
      importe: { $ifNull: ["$importe", 0] },
      categoria: {
        $cond: {
          if: { $gte: ["$importe", 200] },
          then: "alta",
          else: "baja"
        }
      },
      rango: {
        $switch: {
          branches: [
            { case: { $lt: ["$importe", 100] }, then: "baja" },
            { case: { $lte: ["$importe", 200] }, then: "media" }
          ],
          default: "alta"
        }
      }
    }
  }
]);
```

### Salida determinista

Para que una agregación produzca la **misma salida en cada ejecución** (requisito de los ejercicios):

- Termina siempre con `$sort` explícito (un orden concreto).
- Proyecta `_id: 0` al final para no imprimir `ObjectId` variables.
- **Renombra la clave de grupo**: en `$group` la agrupación se llama `_id`; en `$project` final se renombra a un nombre descriptivo (`vendedor: "$_id"`).

```js
db.ventas.aggregate([
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
  { $sort: { total: -1 } },
  { $project: { _id: 0, vendedor: "$_id", total: 1 } }
]);
```

> ⚠️ El campo `_id` de `$group` es la **clave de agrupación**, no el `_id` del documento. Si no se renombra en `$project`, aparece en la salida tal cual.

## Ejemplos de código

### Bloque 1: totales por vendedor con `$group` y `$sort`

```js
db.ventas.aggregate([
  { $group: { _id: "$vendedor", total: { $sum: "$importe" }, ventas: { $count: {} } } },
  { $sort: { total: -1 } },
  { $project: { _id: 0, vendedor: "$_id", total: 1, ventas: 1 } }
]);
```

### Bloque 2: filtro, cálculo y orden en una sola cadena

```js
db.ventas.aggregate([
  { $match: { ciudad: { $in: ["madrid", "barcelona"] } } },
  { $addFields: { conIva: { $round: [{ $multiply: ["$importe", 1.21] }, 2] } } },
  { $sort: { conIva: -1 } },
  { $limit: 3 },
  { $project: { _id: 0, vendedor: 1, importe: 1, conIva: 1 } }
]);
```

### Bloque 3: `$unwind` y re-agrupación sobre `pedidos`

```js
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $addFields: { subtotal: { $multiply: ["$items.cantidad", "$items.precio"] } } },
  { $group: { _id: "$cliente", total: { $sum: "$subtotal" } } },
  { $sort: { total: -1 } },
  { $project: { _id: 0, cliente: "$_id", total: 1 } }
]);
```

### Bloque 4: `$lookup` entre `libros` y `autores`

```js
db.libros.aggregate([
  { $lookup: { from: "autores", localField: "autor_id", foreignField: "_id", as: "autor" } },
  { $unwind: "$autor" },
  { $sort: { anio: 1 } },
  { $project: { _id: 0, titulo: 1, anio: 1, autor: "$autor.nombre" } }
]);
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/)
  - [Group y Sum](ejercicios/nivel-03-intermedio/ejercicio-01-group-y-sum/ejercicio-01-group-y-sum.md)
  - [Project y Campos](ejercicios/nivel-03-intermedio/ejercicio-02-project-y-campos/ejercicio-02-project-y-campos.md)
  - [Lookup (join)](ejercicios/nivel-03-intermedio/ejercicio-03-lookup-join/ejercicio-03-lookup-join.md)
  - [Unwind](ejercicios/nivel-03-intermedio/ejercicio-04-unwind/ejercicio-04-unwind.md)
  - [Sort, Limit y Skip](ejercicios/nivel-03-intermedio/ejercicio-05-sort-limit-skip/ejercicio-05-sort-limit-skip.md)
  - [Condicionales](ejercicios/nivel-03-intermedio/ejercicio-06-condicionales/ejercicio-06-condicionales.md)

## Errores comunes

1. **Usar agregación para todo, incluso donde `find` basta**
   - **Causa**: el pipeline es más costoso de leer y ejecutar que un `find` simple.
   - **Solución**: para filtrar/ordenar/proyectar usa `find`; reserva el pipeline para `$group`, `$lookup` o `$unwind`.

2. **Olvidar el prefijo `$` al referenciar campos en `$group`**
   - **Causa**: en `$group: { _id: "vendedor" }` la cadena se trata como literal.
   - **Solución**: escribe `"$vendedor"`; la `$` indica "valor del campo", no el nombre.

3. **Renombrar la clave de grupo sin tocar `_id`**
   - **Causa**: `$group` siempre guarda la clave en `_id`, y la salida lo muestra así.
   - **Solución**: cierra con `{ $project: { _id: 0, vendedor: "$_id", ... } }` para salida limpia y determinista.

4. **`$lookup` que devuelve arrays anidados**
   - **Causa**: `$lookup` añade un **array** `as`, no un objeto.
   - **Solución**: añade `{ $unwind: "$autor" }` para desanidar la coincidencia única.

5. **`$unwind` "pierde" documentos con array vacío**
   - **Causa**: los arrays vacíos no emiten ningún documento.
   - **Solución**: usa `{ $unwind: { path: "$items", preserveNullAndEmptyArrays: true } }` si quieres conservarlos.

6. **Arreglo de operandos en las expresiones**
   - **Causa**: `$add`, `$multiply`, `$cond` reciben **arrays**: `{ $add: ["$a", "$b"] }`, no argumentos sueltos.
   - **Solución**: revisa la sintaxis; en `$project` con `1`/`0` y expresiones mezcladas, verifica que la proyección no devuelva `_id` no deseado.

7. **Salida no determinista**
   - **Causa**: sin `$sort` final el orden varía entre ejecuciones; el `_id` de los documentos varía en cada inserción.
   - **Solución**: termina con `$sort`, proyecta `_id: 0` y renombra la clave de grupo.

## Recursos

- Agregación (manual oficial): https://www.mongodb.com/docs/manual/aggregation/
- Referencia de etapas del pipeline: https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/
- Operador `$group`: https://www.mongodb.com/docs/manual/reference/operator/aggregation/group/
- Operador `$lookup`: https://www.mongodb.com/docs/manual/reference/operator/aggregation/lookup/
- Operador `$unwind`: https://www.mongodb.com/docs/manual/reference/operator/aggregation/unwind/
- Expresiones del pipeline: https://www.mongodb.com/docs/manual/reference/operator/aggregation/
