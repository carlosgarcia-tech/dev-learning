# 02 — Operadores de consulta

## Objetivos

- [ ] Conocer la sintaxis general de los operadores de consulta dentro del filtro `{ campo: { $operador: valor } }`
- [ ] Aplicar operadores de comparación: `$eq`, `$ne`, `$gt`, `$gte`, `$lt`, `$lte`, `$in`, `$nin`
- [ ] Combinar condiciones con `$and` (implícito y explícito), `$or`, `$not` y `$nor`
- [ ] Filtrar por existencia y tipo con `$exists` y `$type`
- [ ] Buscar texto con `$regex` y `$options` (`"i"`), y distinguir los patrones anclados que aprovechan el índice
- [ ] Consultar arrays: coincidencia exacta, elemento simple, `$all`, `$size` y `$elemMatch`
- [ ] Consultar documentos embebidos con dot notation y con coincidencia exacta del documento completo
- [ ] Aplicar `$elemMatch` sobre arrays de documentos embebidos y saber cuándo es necesario
- [ ] Proyectar subcampos anidados con dot notation en la proyección
- [ ] Obtener valores únicos con `distinct` y contar documentos con `countDocuments`
- [ ] Reutilizar operadores de consulta en los filtros de `update` y en la etapa `$match` de agregación
- [ ] Producir salida determinista con proyección `_id: 0`, `.sort()` y `printjson`

## Apuntes

### Sintaxis general

El primer argumento de `find` es un **filtro** (objeto BSON). Para filtrar por un valor exacto basta la forma corta `{ campo: valor }`, que es un atajo de `{ campo: { $eq: valor } }`. Los operadores de consulta empiezan por `$` y se colocan **dentro** del campo:

```js
{ campo: { $operador: valor } }
```

Existen varias familias. Los operadores de comparación van dentro del campo, mientras que los lógicos de nivel superior (`$and`, `$or`, `$nor`) van en la **raíz** del filtro:

| Familia | Operadores | Sintaxis |
|---|---|---|
| Comparación | `$eq`, `$ne`, `$gt`, `$gte`, `$lt`, `$lte`, `$in`, `$nin` | `{ precio: { $gte: 50 } }` |
| Lógica | `$and`, `$or`, `$nor`, `$not` | `{ $or: [ ... ] }`, `{ precio: { $not: { $gt: 100 } } }` |
| Elemento | `$exists`, `$type` | `{ stock: { $exists: true } }` |
| Regex | `$regex`, `$options` | `{ nombre: { $regex: "^mon", $options: "i" } }` |
| Arrays | `$all`, `$size`, `$elemMatch` | `{ etiquetas: { $size: 2 } }` |
| Evaluación | `$expr`, `$where` | `{ $expr: { $gt: [ "$stock", 0 ] } }` |

### Datos de ejemplo

Todos los ejemplos usan esta colección `productos`, con arrays (`etiquetas`, `valoraciones`) y documentos embebidos (`fabricante`). Es el mismo estilo de datos que cargan los ejercicios del nivel 02.

```js
db.productos.drop();
db.productos.insertMany([
  { nombre: "Monitor",     precio: 349,   stock: 12, categoria: "informatica",  etiquetas: ["pantallas", "ofertas"],    fabricante: { nombre: "LogiTech", pais: "España" },  valoraciones: [{ usuario: "ana",  puntuacion: 5 }, { usuario: "luis", puntuacion: 4 }] },
  { nombre: "Ratón",       precio: 25.99, stock: 40, categoria: "informatica",  etiquetas: ["perifericos"],            fabricante: { nombre: "LogiTech", pais: "España" },  valoraciones: [{ usuario: "ana",  puntuacion: 3 }] },
  { nombre: "Teclado",     precio: 45,    stock: 5,  categoria: "informatica",  etiquetas: ["perifericos", "ofertas"], fabricante: { nombre: "Herman",   pais: "Alemania" }, valoraciones: [{ usuario: "luis", puntuacion: 5 }] },
  { nombre: "Silla",       precio: 199,   stock: 6,  categoria: "hogar",        etiquetas: ["muebles"],                fabricante: { nombre: "Mobilia",  pais: "Italia" } },
  { nombre: "Lámpara",     precio: 27.99, stock: 0,  categoria: "hogar",        etiquetas: ["iluminacion"],            fabricante: { nombre: "Mobilia",  pais: "Italia" } },
  { nombre: "Auriculares", precio: 79.9,  stock: 3,  categoria: "accesorios",   etiquetas: ["audio", "perifericos"],   fabricante: { nombre: "LogiTech", pais: "España" },  valoraciones: [{ usuario: "ana",  puntuacion: 4 }, { usuario: "luis", puntuacion: 2 }] },
  { nombre: "Portátil",    precio: 899,   stock: 10, categoria: "informatica",  etiquetas: ["portatiles", "ofertas"],  fabricante: { nombre: "Herman",   pais: "Alemania" }, valoraciones: [{ usuario: "luis", puntuacion: 5 }] }
]);
```

> 💡 En `mongosh` los valores numéricos enteros se guardan como `int32`/`int64` y los decimales como `double`. `$type` los distingue, pero `$type: "number"` abarca todos.

### Operadores de comparación

Comparan el valor del campo contra un valor (o lista) y son la base de casi toda consulta.

| Operador | Significado | Ejemplo |
|---|---|---|
| `$eq` | Igual a | `{ precio: { $eq: 199 } }` |
| `$ne` | Distinto de | `{ categoria: { $ne: "hogar" } }` |
| `$gt` | Mayor que | `{ precio: { $gt: 100 } }` |
| `$gte` | Mayor o igual | `{ stock: { $gte: 10 } }` |
| `$lt` | Menor que | `{ stock: { $lt: 5 } }` |
| `$lte` | Menor o igual | `{ precio: { $lte: 30 } }` |
| `$in` | Está en la lista | `{ precio: { $in: [349, 899] } }` |
| `$nin` | No está en la lista | `{ categoria: { $nin: ["hogar", "accesorios"] } }` |

```js
db.productos.find({ precio: { $eq: 199 } }, { nombre: 1, precio: 1, _id: 0 });
db.productos.find({ precio: { $gt: 100 } }, { nombre: 1, precio: 1, _id: 0 }).sort({ precio: 1 });
db.productos.find({ stock: { $lte: 5 } }, { nombre: 1, stock: 1, _id: 0 });
db.productos.find({ precio: { $in: [349, 899] } }, { nombre: 1, _id: 0 });
db.productos.find({ categoria: { $nin: ["hogar", "accesorios"] } }, { nombre: 1, _id: 0 });
```

**Puntos clave:**

- `{ precio: 199 }` es un atajo de `{ precio: { $eq: 199 } }`.
- Se pueden combinar varios operadores sobre el **mismo** campo para formar rangos:

```js
db.productos.find({ precio: { $gte: 30, $lt: 100 } }, { nombre: 1, precio: 1, _id: 0 });
```

- `$ne` y `$nin` también devuelven los documentos donde el campo **no existe** (no solo los que tienen otro valor).

### Operadores lógicos

#### `$and` implícito y explícito

Varias condiciones en el mismo objeto ya funcionan como un `AND`:

```js
db.productos.find({ categoria: "informatica", stock: { $gte: 10 } }, { nombre: 1, _id: 0 });
```

El `$and` explícito (una lista de condiciones) es necesario cuando la **misma** condición se repite con valores distintos o se quiere agrupar con claridad:

```js
db.productos.find({
  $and: [
    { categoria: "informatica" },
    { stock: { $gte: 10 } }
  ]
}, { nombre: 1, _id: 0 });
```

#### `$or` y `$nor`

`$or` devuelve los documentos que cumplen **al menos una** de las condiciones; `$nor` devuelve los que no cumplen **ninguna**:

```js
db.productos.find(
  { $or: [ { categoria: "hogar" }, { precio: { $lt: 30 } } ] },
  { nombre: 1, precio: 1, categoria: 1, _id: 0 }
);

db.productos.find(
  { $nor: [ { categoria: "hogar" }, { stock: 0 } ] },
  { nombre: 1, _id: 0 }
);
```

#### `$not`

`$not` niega una condición **dentro de un campo** y no puede ir solo a nivel raíz:

```js
db.productos.find({ precio: { $not: { $gt: 100 } } }, { nombre: 1, precio: 1, _id: 0 });
```

> ⚠️ `$not` no comprueba existencia por sí solo: para negar "que el campo exista" hay que combinarlo con `$exists`.

### Operadores de elemento

#### `$exists`

Comprueba la **presencia** del campo, independientemente de su valor (un `null` cuenta como existente):

```js
db.productos.find({ valoraciones: { $exists: true } }, { nombre: 1, _id: 0 });
db.productos.find({ valoraciones: { $exists: false } }, { nombre: 1, _id: 0 });
```

#### `$type`

Filtra por el **tipo BSON** del campo. Acepta el nombre del tipo o su código numérico:

```js
db.productos.find({ etiquetas: { $type: "array" } }, { nombre: 1, _id: 0 });
db.productos.find({ fabricante: { $type: "object" } }, { nombre: 1, _id: 0 });
db.productos.find({ precio: { $type: "number" } }, { nombre: 1, _id: 0 });
```

| Nombre | Código | Significado |
|---|---|---|
| `double` | 1 | Número en coma flotante |
| `string` | 2 | Cadena de texto |
| `object` | 3 | Documento embebido |
| `array` | 4 | Array |
| `bool` | 8 | Booleano |
| `date` | 9 | Fecha |
| `null` | 10 | Valor nulo |
| `int` | 16 | Entero de 32 bits |
| `objectId` | 7 | ObjectId |

### Expresiones regulares: `$regex`

Busca texto por **patrón**. La forma con operadores es:

```js
db.productos.find({ nombre: { $regex: "tec", $options: "i" } }, { nombre: 1, _id: 0 });
db.productos.find({ nombre: { $regex: "^mon", $options: "i" } }, { nombre: 1, _id: 0 });
```

También existe el atajo `/patron/opciones`, más conciso en JavaScript:

```js
db.productos.find({ nombre: /^mon/i }, { nombre: 1, _id: 0 });
```

| Patrón | Significado |
|---|---|
| `"tec"` | Contiene la subcadena `tec` en cualquier posición |
| `"^mon"` | Empieza por `mon` (**anclado al inicio**) |
| `"ador$"` | Termina por `ador` (anclado al final) |
| `"^[st]"` | Empieza por `s` o `t` |

**Rendimiento:** un patrón anclado al inicio (`^`) puede usar un **índice** sobre el campo; los patrones sin anclar fuerzan un *collection scan* y la opción `"i"` (insensible a mayúsculas) también impide usar índices normales. Si necesitas búsqueda por texto insensible, plantéate índices de texto o `$regex` con prefijo fijo en datos pequeños.

> 💡 `$options` solo se puede usar con `$regex` (forma con operador). Sus valores más útiles: `"i"` (case-insensitive) y `"m"` (multilínea).

### Consultas sobre arrays

Un array se puede consultar de varias maneras según la intención:

```js
// 1. Coincidencia exacta: mismo orden y misma longitud
db.productos.find({ etiquetas: ["perifericos"] }, { nombre: 1, _id: 0 });

// 2. Algún elemento del array coincide (sin orden)
db.productos.find({ etiquetas: "ofertas" }, { nombre: 1, _id: 0 });

// 3. Todos los valores indicados están presentes (cualquier orden, permite extras)
db.productos.find({ etiquetas: { $all: ["perifericos", "audio"] } }, { nombre: 1, _id: 0 });

// 4. Longitud exacta del array
db.productos.find({ etiquetas: { $size: 2 } }, { nombre: 1, _id: 0 });
```

| Operador | Semántica |
|---|---|
| `["a", "b"]` (exacto) | El array completo, mismo orden y misma longitud |
| `"a"` (simple) | Al menos un elemento es igual a `"a"` |
| `$all` | Todos los valores están presentes (independiente del orden) |
| `$size` | El array tiene exactamente N elementos |
| `$elemMatch` | Al menos un elemento cumple **todas** las condiciones a la vez |

> ⚠️ `$size` no acepta rangos (no existe `{ $size: { $gte: 2 } }`). Para "más de N elementos" se suele guardar un contador derivado o usar `$expr`.

### Documentos embebidos: dot notation

Para consultar un campo dentro de un documento embebido se usa la **dot notation**: el nombre del campo con el camino separado por puntos, siempre **entre comillas** en el filtro:

```js
db.productos.find({ "fabricante.pais": "España" }, { nombre: 1, _id: 0 });
```

Si quieres el documento embebido **completo** y exacto, puedes pasarlo como valor directo, pero la comparación es estricta: debe coincidir **toda la estructura** y **el orden de los campos**:

```js
db.productos.find({ fabricante: { nombre: "LogiTech", pais: "España" } }, { nombre: 1, _id: 0 });
// NO coincide con { fabricante: { pais: "España", nombre: "LogiTech" } }  ← orden distinto
```

| Enfoque | Ejemplo | Cuándo usarlo |
|---|---|---|
| Dot notation | `{ "fabricante.pais": "España" }` | Solo necesitas un subcampo |
| Documento exacto | `{ fabricante: { nombre: "LogiTech", pais: "España" } }` | Necesitas toda la estructura, orden exacto |

### Arrays de documentos embebidos: `$elemMatch`

Con `{ "valoraciones.usuario": "ana" }` MongoDB busca cualquier elemento del array que cumpla esa condición. Pero si exiges **varias condiciones sobre el mismo elemento**, la dot notation puede combinarlas entre elementos distintos. Para exigir que **un mismo elemento** las cumpla todas se usa `$elemMatch`:

```js
db.productos.find(
  { valoraciones: { $elemMatch: { usuario: "ana", puntuacion: { $gte: 4 } } } },
  { nombre: 1, _id: 0 }
);
```

```
sin $elemMatch:  "ana" (puntuación 3)  +  "luis" (puntuación 5)  → coincidiría ✗
con $elemMatch:  el MISMO elemento "ana" con puntuación ≥ 4      → correcto ✓
```

### Proyección de subcampos anidados

La proyección también acepta dot notation para devolver solo un subcampo del documento embebido:

```js
db.productos.find(
  { "fabricante.pais": "España" },
  { nombre: 1, "fabricante.nombre": 1, _id: 0 }
).sort({ nombre: 1 });
```

Recuerda las reglas de la guía 01: **no mezclar** inclusiones (`1`) y exclusiones (`0`), salvo `_id: 0`.

### `distinct` y `countDocuments`

```js
db.productos.distinct("categoria");   // ["accesorios", "hogar", "informatica"]
db.productos.distinct("etiquetas");   // aplana los arrays: ["audio", "iluminacion", ...]
db.productos.countDocuments();        // 7
db.productos.countDocuments({ precio: { $gte: 100 } });   // 4
```

- `distinct("campo")` devuelve un **array** con los valores únicos del campo en toda la colección; sobre un campo de tipo array, aplana los valores de todos los documentos.
- `countDocuments(filtro)` devuelve el número de documentos que cumplen el filtro (sin filtro, el total).

### Operadores de consulta en otros contextos

Los operadores de consulta no son exclusivos de `find`. Se reutilizan en:

1. **Filtros de `update`** (primer argumento) y `delete`:

```js
db.productos.updateMany(
  { precio: { $lt: 30 }, enOferta: { $exists: false } },
  { $set: { enOferta: true } }
);
```

2. **Etapa `$match`** del aggregation pipeline, que acepta exactamente los mismos filtros:

```js
db.productos.aggregate([
  { $match: { categoria: "informatica", precio: { $gte: 50 } } },
  { $project: { nombre: 1, precio: 1, _id: 0 } }
]);
```

3. **`$expr`** para comparar campos del documento entre sí (nivel raíz, en `find` o `$match`):

```js
db.productos.find(
  { $expr: { $gt: [ "$stock", 0 ] } },
  { nombre: 1, stock: 1, _id: 0 }
);
```

### Salida determinista

Los ejercicios del nivel 02 comparan la salida del shell con un archivo esperado (`expected.txt`), así que la salida debe ser **estable**. Tres hábitos que ya se usaban en la guía 01:

```js
// 1. Proyección _id: 0 para no imprimir ObjectId variables
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 });
// 2. .sort() explícito para fijar el orden de los resultados
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 }).sort({ precio: -1 });
// 3. printjson dentro de forEach para una salida formateada y uniforme
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));
```

En scripts usa `--quiet --file`:

```bash
mongosh mongodb://localhost:27017/tienda --quiet --file consulta.js
```

## Ejemplos de código

### Bloque 1: datos de ejemplo

```js
db.productos.drop();
db.productos.insertMany([
  { nombre: "Monitor",     precio: 349,   stock: 12, categoria: "informatica",  etiquetas: ["pantallas", "ofertas"],    fabricante: { nombre: "LogiTech", pais: "España" },  valoraciones: [{ usuario: "ana",  puntuacion: 5 }, { usuario: "luis", puntuacion: 4 }] },
  { nombre: "Ratón",       precio: 25.99, stock: 40, categoria: "informatica",  etiquetas: ["perifericos"],            fabricante: { nombre: "LogiTech", pais: "España" },  valoraciones: [{ usuario: "ana",  puntuacion: 3 }] },
  { nombre: "Teclado",     precio: 45,    stock: 5,  categoria: "informatica",  etiquetas: ["perifericos", "ofertas"], fabricante: { nombre: "Herman",   pais: "Alemania" }, valoraciones: [{ usuario: "luis", puntuacion: 5 }] },
  { nombre: "Silla",       precio: 199,   stock: 6,  categoria: "hogar",        etiquetas: ["muebles"],                fabricante: { nombre: "Mobilia",  pais: "Italia" } },
  { nombre: "Lámpara",     precio: 27.99, stock: 0,  categoria: "hogar",        etiquetas: ["iluminacion"],            fabricante: { nombre: "Mobilia",  pais: "Italia" } },
  { nombre: "Auriculares", precio: 79.9,  stock: 3,  categoria: "accesorios",   etiquetas: ["audio", "perifericos"],   fabricante: { nombre: "LogiTech", pais: "España" },  valoraciones: [{ usuario: "ana",  puntuacion: 4 }, { usuario: "luis", puntuacion: 2 }] },
  { nombre: "Portátil",    precio: 899,   stock: 10, categoria: "informatica",  etiquetas: ["portatiles", "ofertas"],  fabricante: { nombre: "Herman",   pais: "Alemania" }, valoraciones: [{ usuario: "luis", puntuacion: 5 }] }
]);
```

### Bloque 2: comparación

```js
db.productos.find({ precio: { $eq: 199 } }, { nombre: 1, precio: 1, _id: 0 });
db.productos.find({ precio: { $gt: 100 } }, { nombre: 1, precio: 1, _id: 0 }).sort({ precio: 1 });
db.productos.find({ precio: { $gte: 30, $lt: 100 } }, { nombre: 1, precio: 1, _id: 0 });
db.productos.find({ categoria: { $nin: ["hogar", "accesorios"] } }, { nombre: 1, _id: 0 });
```

### Bloque 3: lógicos

```js
db.productos.find({ categoria: "informatica", stock: { $gte: 10 } }, { nombre: 1, _id: 0 });
db.productos.find({ $or: [ { categoria: "hogar" }, { precio: { $lt: 30 } } ] }, { nombre: 1, precio: 1, _id: 0 });
db.productos.find({ $nor: [ { categoria: "hogar" }, { stock: 0 } ] }, { nombre: 1, _id: 0 });
db.productos.find({ precio: { $not: { $gt: 100 } } }, { nombre: 1, precio: 1, _id: 0 });
```

### Bloque 4: elemento, regex y arrays

```js
db.productos.find({ valoraciones: { $exists: false } }, { nombre: 1, _id: 0 });
db.productos.find({ etiquetas: { $type: "array" } }, { nombre: 1, _id: 0 });
db.productos.find({ nombre: { $regex: "^mon", $options: "i" } }, { nombre: 1, _id: 0 });
db.productos.find({ etiquetas: { $all: ["perifericos", "audio"] } }, { nombre: 1, _id: 0 });
db.productos.find({ etiquetas: { $size: 2 } }, { nombre: 1, _id: 0 });
db.productos.find({ valoraciones: { $elemMatch: { usuario: "ana", puntuacion: { $gte: 4 } } } }, { nombre: 1, _id: 0 });
```

### Bloque 5: embebidos, proyección y agregados

```js
db.productos.find({ "fabricante.pais": "España" }, { nombre: 1, _id: 0 });
db.productos.find({ "fabricante.pais": "España" }, { nombre: 1, "fabricante.nombre": 1, _id: 0 }).sort({ nombre: 1 });
db.productos.distinct("categoria");
db.productos.countDocuments({ precio: { $gte: 100 } });
db.productos.updateMany({ precio: { $lt: 30 } }, { $set: { enOferta: true } });
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](ejercicios/nivel-02-basico/)
  - [Comparación](ejercicios/nivel-02-basico/ejercicio-01-comparacion/) — `$gt`, `$gte`, `$lte`, `$in`, `$nin`
  - [Lógicos](ejercicios/nivel-02-basico/ejercicio-02-logicos/) — `$and`, `$or`, `$not`, `$nor`
  - [Regex y Existe](ejercicios/nivel-02-basico/ejercicio-03-regex-y-existe/) — `$regex`, `$options`, `$exists`, `$type`
  - [Arrays](ejercicios/nivel-02-basico/ejercicio-04-arrays/) — coincidencia exacta, `$all`, `$size`, `$elemMatch`
  - [Campos Embebidos](ejercicios/nivel-02-basico/ejercicio-05-campos-embebidos/) — dot notation, embebidos, proyección de subcampos
  - [Agregados Básicos](ejercicios/nivel-02-basico/ejercicio-06-agregados-basicos/) — `countDocuments`, `distinct`

## Errores comunes

1. **Olvidar las comillas en la dot notation**
   - **Causa**: `{ fabricante.pais: "España" }` se interpreta como una clave con puntos literal en la raíz.
   - **Solución**: escribe el camino entre comillas: `{ "fabricante.pais": "España" }`.

2. **Coincidencia exacta de array que no aparece**
   - **Causa**: `{ etiquetas: ["perifericos"] }` exige orden y longitud exactos; un array con más elementos no coincide.
   - **Solución**: usa `"etiquetas": "ofertas"` (elemento simple) o `$all`/`$size` según lo que quieras.

3. **Comparar el documento embebido completo y no encontrar nada**
   - **Causa**: la igualdad de un objeto exige el mismo orden de campos y la misma estructura completa.
   - **Solución**: usa dot notation sobre el subcampo concreto, no el objeto entero.

4. **Condiciones de `$elemMatch` que se cumplen en elementos distintos**
   - **Causa**: `{ "valoraciones.usuario": "ana", "valoraciones.puntuacion": { $gte: 4 } }` puede combinar un elemento y otro.
   - **Solución**: envuelve las condiciones en `$elemMatch` para que las cumpla el mismo elemento.

5. **Usar `$size` con un rango**
   - **Causa**: `{ etiquetas: { $size: { $gte: 2 } } }` es inválido; `$size` solo acepta un número.
   - **Solución**: compara con `$expr` y `$size` de agregación, o guarda un contador derivado.

6. **`$not` en la raíz del filtro**
   - **Causa**: `$not` es un operador de campo; `{ $not: { ... } }` como filtro completo falla.
   - **Solución**: colócalo dentro del campo: `{ precio: { $not: { $gt: 100 } } }`.

7. **Confiar en el orden de `find()` sin `.sort()`**
   - **Causa**: el orden por defecto es indeterminado (típicamente por `_id`, que varía).
   - **Solución**: fija `.sort({ campo: 1 })` y proyecta `_id: 0` para salida determinista.

8. **`$regex` sin anclar que no usa el índice**
   - **Causa**: los patrones con `^` pueden usar índice; los demás hacen un scan.
   - **Solución**: para volúmenes grandes, ancla el prefijo (`^`) o usa índices de texto.

## Recursos

- Operadores de consulta: https://www.mongodb.com/docs/manual/reference/operator/query/
- Operadores de comparación: https://www.mongodb.com/docs/manual/reference/operator/query-comparison/
- Operadores lógicos: https://www.mongodb.com/docs/manual/reference/operator/query-logical/
- Operadores de elemento (`$exists`, `$type`): https://www.mongodb.com/docs/manual/reference/operator/query-element/
- `$regex`: https://www.mongodb.com/docs/manual/reference/operator/query/regex/
- Consultas sobre arrays (`$all`, `$size`, `$elemMatch`): https://www.mongodb.com/docs/manual/tutorial/query-arrays/
- Consultas sobre documentos embebidos: https://www.mongodb.com/docs/manual/tutorial/query-embedded-documents/
- `db.collection.distinct()`: https://www.mongodb.com/docs/manual/reference/method/db.collection.distinct/
- `db.collection.countDocuments()`: https://www.mongodb.com/docs/manual/reference/method/db.collection.countDocuments/
