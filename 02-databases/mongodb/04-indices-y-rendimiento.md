# 04 — Índices y rendimiento

## Objetivos

- [ ] Comprender por qué existen los índices y el problema del *collection scan* completo
- [ ] Conocer los costes de un índice: escrituras más lentas y almacenamiento adicional
- [ ] Crear, listar y eliminar índices de un solo campo: `createIndex`, `getIndexes`, `dropIndex`
- [ ] Interpretar los nombres de índice (`precio_1`, `anio_1_mes_-1`) y la dirección `1`/`-1`
- [ ] Construir índices compuestos y aplicar el **principio de prefijo** (el orden de los campos importa)
- [ ] Leer `explain("executionStats")`: `nReturned`, `totalKeysExamined`, `totalDocsExamined` y `winningPlan`
- [ ] Crear índices de texto con `{ campo: "text" }` y buscar con `$text $search`
- [ ] Buscar frases exactas entre comillas y excluir términos con `-`
- [ ] Ordenar resultados de texto por relevancia con `{ $meta: "textScore" }`
- [ ] Crear índices geoespaciales `2dsphere` y consultar con `$near` y `$geoWithin` (`$box`, `$centerSphere`)
- [ ] Entender las unidades: radianes en consultas esféricas y metros en `$near`
- [ ] Usar `updateOne` con `upsert: true` y los operadores de arrays `$push`, `$pull`, `$addToSet`
- [ ] Crear colecciones con validación de esquema usando `$jsonSchema` y capturar el error `DocumentValidationFailure`
- [ ] Verificar la validación con `getCollectionInfos`
- [ ] Imprimir salida determinista: campos estables de `explain`, mapa de índices `name`/`key` y códigos de error

## Apuntes

### ¿Qué es un índice y por qué importa?

Un **índice** es una estructura auxiliar que MongoDB mantiene aparte de los documentos y que ordena los valores de uno o más campos para poder localizarlos sin leer la colección entera.

Sin índice, cada consulta recorre **todos** los documentos de la colección comparando uno a uno: es un *collection scan* (`COLLSCAN`) de coste **O(N)**. Con un índice, MongoDB baja por una estructura de árbol balanceado (**B-tree**) en **O(log N)** y solo recupera los documentos que realmente cumplen el filtro.

```
sin índice (COLLSCAN)                       con índice (IXSCAN)
┌─────────────────────────┐                ┌─────────────────────────┐
│ leer documento  1       │                │  precio_1  (B-tree)     │
│ leer documento  2       │  O(N)          │   10  → doc 1           │
│ leer documento  3       │───────────►    │   25  → doc 2           │
│ ...                     │  N lecturas    │  150  → doc 3           │
│ leer documento N        │                └─────────────────────────┘
└─────────────────────────┘                solo el puntero que aplica
```

**Contrapartidas (trade-offs):**

| Ventaja | Coste |
|---|---|
| Lecturas mucho más rápidas (rango, igualdad, orden) | Cada escritura (`insert`, `update`, `delete`) también actualiza el índice |
| Evita el escaneo completo en colecciones grandes | Ocupa **almacenamiento extra** (el índice vive en RAM y disco) |
| Permite ordenar sin un `.sort()` en memoria | Más índices = escrituras más lentas y más memoria |

> **Regla práctica**: indexa lo que **consultas**, no lo que guardas. Un índice por colección en exceso puede empeorar el rendimiento de escritura. Antes de crear uno, pregúntate: *¿esta consulta se ejecuta a menudo y sobre una colección grande?*

### Índices de un solo campo

La forma más básica ordena los valores de **un solo campo**:

```js
db.productos.createIndex({ nombre: 1 });
db.productos.createIndex({ precio: -1 });
```

- `1` = **ascendente**, `-1` = **descendente**. En igualdad de valor, MongoDB puede recorrer el índice en ambas direcciones, así que la dirección solo importa para `.sort()` o rango.
- `createIndex` **devuelve el nombre** del índice (una cadena). Es idempotente: si el índice ya existe, no lo duplica.
- Todo índice tiene un `_id` implícito: `createIndex` sobre `_id` no es necesario, MongoDB lo crea solo.

**Nombre del índice** (sufijo por campo y dirección):

| Índice | Nombre generado |
|---|---|
| `{ nombre: 1 }` | `nombre_1` |
| `{ precio: -1 }` | `precio_-1` |
| `{ anio: 1, mes: -1 }` | `anio_1_mes_-1` |
| `{ titulo: "text" }` | `titulo_text` |
| `{ location: "2dsphere" }` | `location_2dsphere` |

Inspeccionar y eliminar:

```js
db.productos.getIndexes();                          // todos los índices (incluye _id_)
db.productos.dropIndex("nombre_1");                 // elimina por nombre
db.productos.dropIndex({ nombre: 1 });              // también se puede por especificación
```

- `getIndexes()` devuelve un array de objetos con `key` y `name` (entre otros).
- El índice `_id_` **siempre existe y no se puede eliminar**.

> 💡 En los ejercicios del nivel 4, imprime los índices como mapa `name` + `key` con `.map(i => ({ name: i.name, key: i.key }))`: omite campos no deterministas (como `v` o `background`) y la salida es estable entre ejecuciones.

### Índices compuestos

Un índice compuesto ordena por **dos o más campos**. **El orden de los campos es crítico**: determina qué consultas puede servir.

```js
db.ventas.createIndex({ anio: 1, mes: -1 });
```

- Primero se ordena por `anio`, y dentro de cada `anio`, por `mes` en descendente.
- Sirve para consultas sobre `{ anio }` **y** sobre `{ anio, mes }`, pero **no** para consultas solo sobre `{ mes }` (por eso el orden importa).
- Se puede recorrer en ambas direcciones, así que `{ anio: 1, mes: -1 }` también atiende a `sort({ anio: -1, mes: 1 })`.

**Principio de prefijo**: una consulta solo aprovecha el índice si filtra por un **prefijo** de sus campos, en el orden definido.

| Índice | Sí sirve para | No sirve para |
|---|---|---|
| `{ anio: 1, mes: -1 }` | `{ anio: 2024 }`, `{ anio: 2024, mes: 3 }` | `{ mes: 3 }` solo |
| `{ vendedor: 1, importe: -1 }` | `{ vendedor: "ana" }`, `{ vendedor: "ana", importe: { $gte: 100 } }` | `{ importe: { $gte: 100 } }` solo |

> **Regla práctica**: pon primero el campo de **igualdad** y después el de **rango** (`$gte`, `$lt`, `$sort`). Si inviertes el orden, el campo de rango deja de poder usar el índice para el segundo nivel.

### explain("executionStats")

`explain()` muestra **cómo** ejecuta MongoDB una consulta y si usa un índice (`IXSCAN`) o un escaneo completo (`COLLSCAN`):

```js
const e = db.ventas.find({ anio: 2024, mes: 3 }).explain("executionStats");
printjson({
  nReturned: e.executionStats.nReturned,
  totalKeysExamined: e.executionStats.totalKeysExamined,
  totalDocsExamined: e.executionStats.totalDocsExamined,
  stage: e.queryPlanner.winningPlan.stage
});
```

| Campo | Significado | Ideal |
|---|---|---|
| `nReturned` | Documentos devueltos al cliente | tantos como respuestas tenga la consulta |
| `totalKeysExamined` | Entradas del índice revisadas | ≈ `nReturned` |
| `totalDocsExamined` | Documentos completos leídos desde disco | ≈ `nReturned` (sin *fetches* extra) |
| `winningPlan.stage` | Plan ganador: `COLLSCAN` (malo) o `FETCH` → `IXSCAN` (bueno) | `IXSCAN` |

**Cómo leerlo**: si `totalDocsExamined` ≈ `totalKeysExamined` ≈ `nReturned`, la consulta es eficiente (usa el índice de principio a fin). Si `totalKeysExamined` o `totalDocsExamined` son mucho mayores que `nReturned`, falta un índice o el filtro no es un prefijo de ninguno existente. Y si `stage` es `COLLSCAN`, la colección se está recorriendo entera.

> ⚠️ No imprimas el objeto completo de `explain`: contiene tiempos (`executionTimeMillis`), índices de memoria y `ObjectId` que **varían entre ejecuciones**. En el curso se imprimen **solo** los campos estables de `executionStats` y la etapa del `winningPlan`.

### Índices de texto

Los índices de texto permiten buscar **palabras dentro de campos de string** (sin coincidencia exacta) usando `$text`:

```js
db.articulos.createIndex({ titulo: "text", contenido: "text" });
```

- El tipo es el string `"text"`. Un índice compuesto de texto puede incluir varios campos de texto.
- **Una colección solo puede tener un índice de texto**.

Búsquedas:

```js
// Término simple
db.articulos.find({ $text: { $search: "mongo" } }, { _id: 0, titulo: 1 });

// Frase exacta: se entrecomilla dentro de $search
db.articulos.find({ $text: { $search: "\"base de datos\"" } }, { _id: 0, titulo: 1 });

// Exclusión: término con "-" delante
db.articulos.find({ $text: { $search: "mongo -shell" } }, { _id: 0, titulo: 1 });
```

| Sintaxis en `$search` | Significado |
|---|---|
| `mongo` | Documentos que contienen la palabra |
| `"base de datos"` | La frase exacta entre comillas |
| `mongo -shell` | Incluye `mongo`, excluye los que tengan `shell` |

**Ordenar por relevancia** con `$meta: "textScore"`, que se usa tanto en la proyección como en el `.sort()`:

```js
db.articulos.find(
  { $text: { $search: "mongo" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));
```

> 💡 Añade un campo extra en el `.sort()` (aquí `titulo: 1`) como desempate: el `textScore` puede coincidir entre documentos y sin ese desempate el orden no es determinista.

### Índices geoespaciales

Para consultar por localización se usa el índice **`2dsphere`** sobre objetos **GeoJSON**. El orden de coordenadas siempre es `[longitud, latitud]`:

```js
db.locales.insertOne({ nombre: "Puerta del Sol", location: { type: "Point", coordinates: [-3.703, 40.417] } });
db.locales.createIndex({ location: "2dsphere" });
```

| Operador | Para qué sirve | Unidades |
|---|---|---|
| `$near` | Puntos próximos a un punto, **ordenados por distancia** | `$maxDistance` en **metros** |
| `$geoWithin` + `$box` | Dentro de un rectángulo (esquinas `[lng, lat]`) | geometría plana |
| `$geoWithin` + `$centerSphere` | Dentro de un círculo sobre la esfera | radio en **radianes** |

```js
// $near: locales a menos de 1 km, más cercanos primero
db.locales.find(
  { location: { $near: { $geometry: { type: "Point", coordinates: [-3.703, 40.417] }, $maxDistance: 1000 } } },
  { _id: 0, nombre: 1 }
);

// $geoWithin con $box (rectángulo)
db.locales.find(
  { location: { $geoWithin: { $box: [[-3.72, 40.40], [-3.68, 40.43]] } } },
  { _id: 0, nombre: 1 }
);

// $geoWithin con $centerSphere (radio ~3 km = 0.0005 radianes)
db.locales.find(
  { location: { $geoWithin: { $centerSphere: [[-3.703, 40.417], 0.0005] } } },
  { _id: 0, nombre: 1 }
);
```

**Conversión a radianes** (solo `$centerSphere`): `radianes = km / 6371` (radio aproximado de la Tierra). Un radio de 3 km ≈ `3 / 6371 ≈ 0.00047`; el ejercicio usa `0.0005`.

> ⚠️ `$box` trabaja con geometría plana (coordenadas heredadas); `$centerSphere` y `$near` con `$geometry` usan geometría esférica, que es la correcta sobre `2dsphere`. `$geoWithin` **no ordena** por distancia; `$near` y `$geoNear` (en agregación) sí.

### Upsert y operadores de arrays

**Upsert**: `updateOne` con `{ upsert: true }` actualiza el primer documento que coincide; si **no hay ninguno**, lo **crea** combinando el filtro y el `$set`:

```js
db.carritos.updateOne(
  { usuario: "marta" },
  { $set: { items: ["mochila"], total: 60 } },
  { upsert: true }
);
```

| Operador | Qué hace | Ejemplo |
|---|---|---|
| `$push` | Añade un elemento **al final** del array | `{ $push: { items: "zapatillas" } }` |
| `$pull` | Elimina **todos** los elementos que coincidan con el valor | `{ $pull: { items: "reloj" } }` |
| `$addToSet` | Añade **solo si no existe** (como un set) | `{ $addToSet: { items: "mochila" } }` |
| `$addToSet` + `$each` | Añade una lista, descartando duplicados | `{ $addToSet: { items: { $each: ["a", "a", "b"] } } }` |

```js
db.carritos.updateOne({ usuario: "ana" }, { $push: { items: "zapatillas" } });
db.carritos.updateOne({ usuario: "luis" }, { $pull: { items: "reloj" } });
db.carritos.updateOne(
  { usuario: "carla" },
  { $addToSet: { items: { $each: ["mochila", "mochila", "libro"] } } }
);
```

> 💡 `$push` **sí duplica**; `$addToSet` **no**. Elige según el significado del dato: una lista de eventos tolera duplicados, una lista de tags únicos no.

### Validación de esquema con $jsonSchema

Aunque MongoDB es *schema-less*, se puede exigir un esquema al **crear la colección** con `createCollection` y un `validator`:

```js
db.createCollection("clientes", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "edad", "email"],
      properties: {
        nombre: { bsonType: "string" },
        edad: { bsonType: "int", minimum: 18 },
        email: { bsonType: "string", pattern: "@" }
      }
    }
  }
});
```

| Palabra clave | Significado |
|---|---|
| `bsonType` | Tipo BSON esperado (`"object"`, `"string"`, `"int"`, `"array"`, ...) |
| `required` | Lista de campos obligatorios |
| `properties` | Reglas por campo (tipo, `minimum`, `pattern`, ...) |
| `minimum` | Valor numérico mínimo (por ejemplo, edad ≥ 18) |

Si una escritura no cumple el esquema, MongoDB la **rechaza** con un error `DocumentValidationFailure` (código `121`). En `mongosh` se captura con `try/catch`:

```js
try {
  db.clientes.insertOne({ nombre: "luis", edad: NumberInt(15), email: "luis@mail.com" });
} catch (e) {
  print("code: " + e.code);        // 121
  print("codeName: " + e.codeName); // DocumentValidationFailure
  print("message: " + e.message);
}
```

> ⚠️ En `mongosh` un `15` plano se guarda como `double`; para que valide `bsonType: "int"` hay que escribirlo con `NumberInt(15)`. Verifica que la validación está activa con `db.getCollectionInfos({ name: "clientes" })`, filtrando a `name` y `options.validator`.

### Inspección determinista para el curso

Los tests del nivel 4 comparan salida exacta, así que hay que imprimir **solo** campos estables:

- **`explain`**: guarda el resultado en una variable y selecciona `nReturned`, `totalKeysExamined`, `totalDocsExamined` y `winningPlan.stage`. Nunca el objeto completo (tiempos y punteros varían).
- **Índices**: imprime el mapa `{ name, key }` con `.map(i => ({ name: i.name, key: i.key }))` en vez de `getIndexes()` crudo.
- **Errores de validación**: el `code` numérico (`121`) y el `codeName` (`DocumentValidationFailure`) son estables; imprime ambos con `print`.
- **Cursus**: `createIndex` imprime el nombre del índice creado; usa `print(db.coleccion.createIndex(...))`.
- Salidas de `find` con proyección `_id: 0` y `.sort()` explícito con desempate, igual que en las guías anteriores.

## Ejemplos de código

### Bloque 1: índices de un solo campo

```js
db.productos.insertMany([
  { nombre: "camisa", precio: 25, categoria: "ropa" },
  { nombre: "reloj", precio: 120, categoria: "accesorios" },
  { nombre: "mochila", precio: 60, categoria: "accesorios" }
]);

print(db.productos.createIndex({ nombre: 1 }));       // nombre_1
print(db.productos.createIndex({ precio: -1 }));      // precio_-1
printjson(db.productos.getIndexes().map(i => ({ name: i.name, key: i.key })));
db.productos.dropIndex("nombre_1");
```

### Bloque 2: índices compuestos y explain

```js
db.ventas.insertMany([
  { anio: 2024, mes: 1, vendedor: "ana", importe: 120 },
  { anio: 2024, mes: 3, vendedor: "carla", importe: 250 },
  { anio: 2025, mes: 3, vendedor: "marta", importe: 175 }
]);

print(db.ventas.createIndex({ anio: 1, mes: -1 }));   // anio_1_mes_-1
print(db.ventas.createIndex({ vendedor: 1, importe: -1 }));

const e = db.ventas.find({ anio: 2024, mes: 3 }).explain("executionStats");
printjson({
  nReturned: e.executionStats.nReturned,
  totalKeysExamined: e.executionStats.totalKeysExamined,
  totalDocsExamined: e.executionStats.totalDocsExamined,
  stage: e.queryPlanner.winningPlan.stage
});
```

### Bloque 3: búsqueda de texto

```js
db.articulos.insertMany([
  { titulo: "Introducción a MongoDB", contenido: "Aprende los fundamentos de mongo y su shell." },
  { titulo: "Búsqueda de texto", contenido: "Una base de datos bien indexada es rápida." }
]);

print(db.articulos.createIndex({ titulo: "text", contenido: "text" }));

db.articulos.find(
  { $text: { $search: "mongo" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));

db.articulos.find(
  { $text: { $search: "\"base de datos\"" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

db.articulos.find(
  { $text: { $search: "mongo -shell" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
```

### Bloque 4: geoespacial

```js
db.locales.insertMany([
  { nombre: "Puerta del Sol", location: { type: "Point", coordinates: [-3.703, 40.417] } },
  { nombre: "Plaza Mayor", location: { type: "Point", coordinates: [-3.707, 40.415] } }
]);

print(db.locales.createIndex({ location: "2dsphere" }));

db.locales.find(
  { location: { $near: { $geometry: { type: "Point", coordinates: [-3.703, 40.417] }, $maxDistance: 1000 } } },
  { _id: 0, nombre: 1 }
).sort({ nombre: 1 }).forEach(d => printjson(d));

db.locales.find(
  { location: { $geoWithin: { $box: [[-3.72, 40.40], [-3.68, 40.43]] } } },
  { _id: 0, nombre: 1 }
).sort({ nombre: 1 }).forEach(d => printjson(d));

db.locales.find(
  { location: { $geoWithin: { $centerSphere: [[-3.703, 40.417], 0.0005] } } },
  { _id: 0, nombre: 1 }
).sort({ nombre: 1 }).forEach(d => printjson(d));
```

### Bloque 5: upsert y arrays

```js
db.carritos.insertMany([
  { usuario: "ana", items: ["camisa", "gorra"], total: 40 },
  { usuario: "luis", items: ["reloj"], total: 120 },
  { usuario: "carla", items: [], total: 0 }
]);

db.carritos.updateOne(
  { usuario: "marta" },
  { $set: { items: ["mochila"], total: 60 } },
  { upsert: true }
);
db.carritos.updateOne({ usuario: "ana" }, { $push: { items: "zapatillas" } });
db.carritos.updateOne({ usuario: "luis" }, { $pull: { items: "reloj" } });
db.carritos.updateOne(
  { usuario: "carla" },
  { $addToSet: { items: { $each: ["mochila", "mochila", "libro"] } } }
);

db.carritos.find({}, { _id: 0 }).sort({ usuario: 1 }).forEach(d => printjson(d));
```

### Bloque 6: validación de esquema

```js
db.createCollection("clientes", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "edad", "email"],
      properties: {
        nombre: { bsonType: "string" },
        edad: { bsonType: "int", minimum: 18 },
        email: { bsonType: "string", pattern: "@" }
      }
    }
  }
});

db.clientes.insertOne({ nombre: "ana", edad: NumberInt(30), email: "ana@mail.com" });

try {
  db.clientes.insertOne({ nombre: "luis", edad: NumberInt(15), email: "luis@mail.com" });
} catch (e) {
  print("code: " + e.code);
  print("codeName: " + e.codeName);
}

printjson(db.getCollectionInfos({ name: "clientes" }).map(c => ({ name: c.name, validator: c.options.validator })));
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/)
  - [Indices Básicos](ejercicios/nivel-04-avanzado/ejercicio-01-indices-basicos/)
  - [Indices Compuestos](ejercicios/nivel-04-avanzado/ejercicio-02-indices-compuestos/)
  - [Indices de Texto](ejercicios/nivel-04-avanzado/ejercicio-03-indices-texto/)
  - [Geospatial](ejercicios/nivel-04-avanzado/ejercicio-04-geospatial/)
  - [Upsert y Arrays](ejercicios/nivel-04-avanzado/ejercicio-05-upsert-y-arrays/)
  - [Validaciones](ejercicios/nivel-04-avanzado/ejercicio-06-validaciones/)

## Errores comunes

1. **Crear un índice para una consulta que ya usa otro mejor**
   - **Causa**: muchos índices pequeños por campos sueltos, en vez de uno compuesto con el prefijo correcto.
   - **Solución**: analiza con `explain`; un `{ a: 1, b: 1 }` sirve a `{ a }` y a `{ a, b }`, así que el índice suelto de `a` suele sobrar.

2. **Ordenar los campos de un índice compuesto al revés**
   - **Causa**: `{ b: 1, a: 1 }` cuando la consulta filtra por `{ a, b }`; el prefijo no coincide.
   - **Solución**: primero los campos de **igualdad**, después los de **rango/orden**; verifica con el `winningPlan`.

3. **`explain` devuelve `COLLSCAN` y no se entiende por qué**
   - **Causa**: no existe un índice cuyo prefijo cubra el filtro, o el campo no está indexado.
   - **Solución**: crea el índice y repite; `winningPlan.stage` debe pasar a `FETCH` → `IXSCAN`.

4. **Imprimir `explain` completo rompe los tests del curso**
   - **Causa**: `executionTimeMillis`, `keysExamined` por nivel y otros campos varían entre ejecuciones.
   - **Solución**: guarda en variable y selecciona solo `nReturned`, `totalKeysExamined`, `totalDocsExamined` y `winningPlan.stage`.

5. **`$text` no devuelve nada o da error**
   - **Causa**: no hay un índice de texto, hay más de uno, o la búsqueda usa campos no indexados.
   - **Solución**: recuerda que una colección admite **un solo** índice de texto y que `$text` solo puede usarlo él.

6. **Olvidar las comillas para una frase exacta**
   - **Causa**: `$search: "base de datos"` busca documentos con ambas palabras, no la frase.
   - **Solución**: entrecomilla dentro del string: `$search: "\"base de datos\""`.

7. **Coordenadas invertidas en GeoJSON**
   - **Causa**: GeoJSON exige `[longitud, latitud]`, y se escribe `[lat, lng]`.
   - **Solución**: usa siempre `coordinates: [lng, lat]` tanto en los documentos como en las consultas.

8. **Radio de `$centerSphere` interpretado como kilómetros**
   - **Causa**: `$centerSphere` espera el radio en **radianes**, no en km o grados.
   - **Solución**: convierte con `km / 6371`; `$near` con `$maxDistance` sí usa metros.

9. **`$push` genera duplicados no deseados**
   - **Causa**: `$push` añade siempre, aunque el valor ya exista.
   - **Solución**: para valores únicos usa `$addToSet` (con `$each` para listas).

10. **`upsert` crea documentos incompletos**
    - **Causa**: el upsert combina filtro + `$set`, pero puede omitir campos que no están en ninguno.
    - **Solución**: incluye en el `$set` todos los campos que el documento nuevo debe tener.

11. **Validación rechaza `edad: 15` pero el insert con `NumberInt(15)` falla igual**
    - **Causa**: otro campo no cumple el esquema (tipo, `pattern` de email, `minimum`), o la colección se creó sin validator.
    - **Solución**: lee el `message` del error, revisa `bsonType` de cada campo y confirma la colección con `getCollectionInfos`.

12. **Salida de `getIndexes()` o del error no es estable**
    - **Causa**: se imprimen campos como `v`, `2dsphereIndexVersion` o el objeto de error completo.
    - **Solución**: filtra a `{ name, key }` para índices y a `code`/`codeName`/`message` para errores.

## Recursos

- Documentación oficial de índices: https://www.mongodb.com/docs/manual/indexes/
- `createIndex`, `getIndexes` y `dropIndex`: https://www.mongodb.com/docs/manual/reference/method/#database-collection-index-management
- Guía de índices compuestos: https://www.mongodb.com/docs/manual/core/index-compound/
- `explain`: https://www.mongodb.com/docs/manual/reference/method/db.collection.explain/
- Índices de texto y `$text`: https://www.mongodb.com/docs/manual/core/index-text/
- Índices `2dsphere`: https://www.mongodb.com/docs/manual/core/2dsphere/
- Operadores de actualización de arrays: https://www.mongodb.com/docs/manual/reference/operator/update-array/
- Validación de esquema con `$jsonSchema`: https://www.mongodb.com/docs/manual/core/schema-validation/
