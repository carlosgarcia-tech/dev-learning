# 01 — Fundamentos de MongoDB

## Objetivos

- [ ] Comprender qué es MongoDB: base de datos NoSQL orientada a documentos (JSON/BSON) y sin esquema
- [ ] Conocer las diferencias frente a una base de datos relacional (RDBMS)
- [ ] Identificar los casos de uso típicos: catálogos, logs, analítica, perfiles de usuario y tiempo real
- [ ] Distinguir la jerarquía de objetos: bases de datos, colecciones, documentos y campos
- [ ] Entender el campo `_id`, el tipo `ObjectId` y su generación automática
- [ ] Decidir entre documentos embebidos y referencias entre colecciones
- [ ] Conocer los tipos BSON: `double`, `string`, `ObjectId`, `boolean`, `date`, `array`, objeto embebido, `null`, etc.
- [ ] Arrancar MongoDB con Podman y conectarse con `mongosh`
- [ ] Realizar CRUD básico: `insertOne`, `insertMany`, `find`, `countDocuments`, `updateOne`/`updateMany` (`$set`, `$inc`), `deleteOne`/`deleteMany`, `drop`
- [ ] Consultar con filtros de igualdad, proyección, `.sort()`, `.limit()`, `.skip()` y `findOne`
- [ ] Aplicar hábitos de `mongosh` para salida determinista: `--quiet`, `--file`, `printjson`, `.forEach`

## Apuntes

### ¿Qué es MongoDB?

MongoDB es una base de datos **NoSQL orientada a documentos**, **open source** y **sin esquema**. Los datos se guardan como **documentos** con formato **BSON** (una extensión binaria de JSON) agrupados en **colecciones** dentro de **bases de datos**.

A diferencia de una base relacional, no hay tablas, filas ni columnas: cada documento es un objeto autocontenido que puede tener **estructura distinta** de la de sus vecinos. No hace falta definir columnas ni migraciones: un documento nuevo puede añadir o quitar campos libremente.

**Diferencias clave frente a una base de datos relacional (RDBMS):**

| Característica | RDBMS (MySQL, PostgreSQL) | MongoDB |
|---|---|---|
| Almacenamiento | Tablas, filas y columnas | Colecciones de documentos |
| Formato del dato | Filas con columnas fijas | Documentos BSON (JSON binario) |
| Esquema | Fijo, definido con DDL/migraciones | Flexible (schema-less) |
| Consultas | SQL declarativo (JOIN) | Métodos de colección en JS (`find`, agregación) |
| Relaciones | JOIN entre tablas | Documentos embebidos o referencias |
| Escalado | Vertical/replicación | Replicación, sharding horizontal nativo |
| Clave primaria | Auto-incremental o UUID | `_id` automático tipo `ObjectId` |

**Casos de uso más comunes:**

1. **Catálogos y contenidos**: productos, artículos, metadata variable (cada categoría puede tener atributos distintos).
2. **Logs y eventos**: ingestión de grandes volúmenes de líneas de log con campos heterogéneos.
3. **Analítica**: consultas sobre métricas y telemetría con agregaciones.
4. **Perfiles de usuario**: cada usuario puede tener atributos distintos y crecer con el producto.
5. **Aplicaciones en tiempo real**: lecturas de baja latencia para paneles, juegos y mensajería.
6. **Content management**: páginas y contenido con estructura variable.

> **Regla práctica**: si tus datos tienen una forma rígida, exigen JOINs complejos y transacciones estrictas multi-fila, un RDBMS encaja mejor. MongoDB brilla cuando la estructura es variable, evoluciona rápido o el volumen exige sharding.

### ¿Dónde encaja MongoDB en la arquitectura?

MongoDB actúa como la **base de datos principal** de la aplicación (frente a Redis, que suele ser caché). La lectura y escritura pasan directamente por Mongo:

```
Cliente / Aplicación
        │
        ▼
   ┌────────────┐    consultas CRUD    ┌──────────────┐
   │  Servidor  │◄─────────────────────►│   MongoDB    │
   │  (app)     │                      │  (BSON/colecciones)
   └────────────┘                      └──────────────┘
```

- Los **documentos** se leen y escriben completos: no hay `JOIN` de disco.
- La **agregación** se puede empujar al servidor con el *aggregation pipeline* (guía avanzada).

### Conceptos fundamentales

#### Jerarquía de objetos

```
MongoDB server
   └── base de datos  (db)            e.g. tienda
         └── colección (collection)    e.g. productos
               └── documento           e.g. { nombre: "Monitor", precio: 150 }
```

| Nivel | Descripción |
|---|---|
| **Base de datos** | Contenedor lógico de colecciones (equivalente a un *schema* en RDBMS) |
| **Colección** | Agrupación de documentos (equivalente a una *tabla*) |
| **Documento** | Unidad de datos, un objeto BSON (equivalente a una *fila*) |
| **Campo** | Par clave-valor dentro del documento (equivalente a una *columna*) |

En `mongosh` se accede con `db.<coleccion>`: `db.productos`, `db.usuarios`, `db.pedidos`.

#### El documento

Un documento es un objeto **JSON-like** que puede mezclar tipos por campo:

```js
{
  _id: ObjectId("5f8a..."),
  nombre: "Monitor 24\"",
  precio: 150,
  stock: 10,
  disponible: true,
  fechaAlta: ISODate("2026-08-01T10:00:00Z"),
  etiquetas: ["pantallas", "ofertas"],
  direccion: { ciudad: "Madrid", cp: "28001" }
}
```

#### El campo `_id`

- Todo documento **debe** tener un campo `_id` único dentro de su colección.
- Si no se indica, MongoDB lo **genera automáticamente** como `ObjectId` al insertar.
- El `ObjectId` es de **12 bytes**: 4 bytes de timestamp + 5 de valor aleatorio por máquina/proceso + 3 de contador.

```
ObjectId("5f8a1f2b3c4d5e6f7a8b9c0d")
 ─────────┬───────── ───────┬─────── ────┬────
  4 bytes timestamp    5 bytes random  3 bytes contador
```

**Reglas de `_id`:**

- Puede ser cualquier tipo BSON que sea único (string, número, etc.), pero el `ObjectId` es el valor por defecto.
- Una vez insertado, **no debe modificarse** (aunque técnicamente es posible).
- Se puede usar el `_id` generado como clave natural (por ejemplo, un string de negocio) si se garantiza unicidad.

#### Documentos embebidos vs referencias

| Criterio | Documento embebido | Referencia (id) |
|---|---|---|
| Dónde viven los datos | Dentro del mismo documento | En otra colección, apuntando con un campo id |
| Lectura | Un solo `find`: todo llega junto | Requiere segunda consulta o `$lookup` |
| Escritura | Atómica en un solo documento | Puede requerir dos escrituras |
| Tamaño | Limitado a 16 MB por documento | Ilimitada en la práctica |
| Uso típico | Relaciones 1:1 y 1:N pequeñas (dirección, items de pedido) | Relaciones 1:N grandes y N:M (autores, tags) |

**Ejemplo de embebido:**

```js
db.pedidos.insertOne({
  _id: ObjectId("..."),
  clienteId: ObjectId("..."),
  items: [
    { nombre: "Ratón", cantidad: 1, precio: 12 },
    { nombre: "Teclado", cantidad: 1, precio: 25 }
  ]
});
```

> 💡 En MongoDB **no existe `JOIN` nativo en `find`**. La regla mental es: *si siempre lees el dato junto con el padre, embrutégalo; si lo consultas de forma independiente o crece sin límite, reférencialo.*

### Tipos de datos BSON

BSON añade tipos que JSON no tiene (fechas, binario, ObjectId). Los más usados:

| Tipo BSON | Ejemplo en `mongosh` | Notas |
|---|---|---|
| `double` | `3.14` | Número de coma flotante |
| `string` | `"hola"` | Texto UTF-8 |
| `ObjectId` | `ObjectId("5f8a1f2b3c4d5e6f7a8b9c0d")` | Id de 12 bytes, se genera solo |
| `boolean` | `true` / `false` | |
| `date` | `ISODate("2026-08-20T10:00:00Z")` | Fecha UTC; `new Date()` crea la actual |
| `array` | `[1, 2, 3]` | Lista ordenada de valores |
| documento embebido | `{ ciudad: "Madrid" }` | Objeto anidado |
| `null` | `null` | Campo presente con valor nulo |
| `int32` / `int64` | `NumberInt(5)` / `NumberLong(5)` | Enteros con tamaño explícito |
| `decimal128` | `NumberDecimal("19.99")` | Precisión decimal exacta (dinero) |
| `binary` | `BinData(0, "...")` | Datos binarios |
| `timestamp` | `Timestamp(...)` | Con contador interno (replicación) |

> ⚠️ En `mongosh` los enteros que escribes como `42` se guardan como `int32` si caben; los decimales como `3.14` como `double`. Para dinero usa `NumberDecimal` a fin de evitar errores de redondeo.

### Instalación y arranque con Podman

La forma más rápida de levantar MongoDB localmente es con un contenedor:

```bash
podman run -d --name mongo -p 27017:27017 docker.io/library/mongo:7
```

Explicación de las opciones:

| Opción | Significado |
|---|---|
| `run` | Crea y ejecuta un contenedor |
| `-d` | Detached: corre en segundo plano |
| `--name mongo` | Nombre del contenedor (para `podman stop/start mongo`) |
| `-p 27017:27017` | Publica el puerto 27017 del contenedor en el host |
| `docker.io/library/mongo:7` | Imagen oficial de MongoDB 7 |

Para ver logs, parar o reiniciar:

```bash
podman logs mongo
podman stop mongo
podman start mongo
```

#### Conexión con mongosh

`mongosh` es el shell oficial de JavaScript de MongoDB. Para conectar:

```bash
mongosh mongodb://localhost:27017
```

Para conectarse directamente a una base de datos:

```bash
mongosh mongodb://localhost:27017/tienda
```

> 💡 El primer argumento tras la URI es el **nombre de la base de datos**. Si no existe, se crea al escribir el primer documento.

### Primeros pasos con mongosh

Sin argumentos, el URI por defecto es `mongodb://127.0.0.1:27017`. El prompt muestra la base activa:

```
$ mongosh mongodb://localhost:27017/tienda
tienda> db.productos.insertOne({ nombre: "Ratón", precio: 12, stock: 40 })
tienda> db.productos.countDocuments()
```

### CRUD básico

#### Insertar: `insertOne` y `insertMany`

```js
db.productos.insertOne({ nombre: "Teclado", precio: 25, stock: 15, categoria: "Periféricos" });

db.productos.insertMany([
  { nombre: "Monitor", precio: 150, stock: 10, categoria: "Pantallas" },
  { nombre: "Webcam", precio: 60, stock: 4, categoria: "Periféricos" }
]);
```

- Ambos devuelven un acuse con el/los `_id` generado(s).
- Si se omite `_id`, MongoDB lo genera automáticamente como `ObjectId`.

#### Leer: `find` y `countDocuments`

```js
db.productos.find();                     // todos los documentos de la colección
db.productos.countDocuments();           // número total de documentos
db.productos.countDocuments({ categoria: "Periféricos" });   // con filtro
```

- `find()` devuelve un **cursor** (los resultados se imprimen al evaluarlo en el shell).
- `countDocuments()` admite un filtro opcional como argumento.

#### Actualizar: `updateOne`, `updateMany`

Los operadores de actualización se pasan como segundo argumento. Los más usados son `$set` (sobrescribe campos) y `$inc` (incrementa numéricamente).

```js
db.productos.updateOne(
  { nombre: "Ratón" },
  { $set: { precio: 15 } }
);

db.productos.updateOne(
  { nombre: "Ratón" },
  { $inc: { stock: -1 } }
);

db.productos.updateMany(
  { categoria: "Periféricos" },
  { $inc: { precio: 5 } }
);
```

- `updateOne` modifica **solo el primer** documento que coincide; `updateMany` todos los que coinciden.
- Si ningún documento coincide, la operación no hace nada (se puede activar *upsert* con `{ upsert: true }`).

#### Eliminar: `deleteOne`, `deleteMany` y `drop`

```js
db.productos.deleteOne({ nombre: "Webcam" });
db.productos.deleteMany({ categoria: "Accesorios" });
db.productos.drop();          // elimina la colección entera (y sus índices)
```

- `deleteOne` elimina el **primer** documento que coincide; `deleteMany` todos.
- `drop` borra la colección completa y es **irreversible**.

### Consultas: filtros, proyección y orden

#### Filtro de igualdad

El primer argumento de `find` es el **filtro** (query):

```js
db.productos.find({ categoria: "Periféricos" });
db.productos.find({ nombre: "Monitor" });
```

#### Proyección

El segundo argumento selecciona qué campos devolver:

| Sintaxis | Efecto |
|---|---|
| `{ campo: 1 }` | Incluye solo los campos indicados (whitelist) |
| `{ campo: 0 }` | Excluye los campos indicados (blacklist) |
| `{ _id: 0 }` | Oculta el `_id` (muy usado para salida determinista) |

```js
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 });
db.productos.find({}, { stock: 0, fechaAlta: 0 });
```

> ⚠️ No se pueden mezclar inclusiones y exclusiones en la misma proyección (salvo `_id`). O incluyes campos concretos o excluyes; no ambas.

#### Ordenar y paginar: `.sort()`, `.limit()`, `.skip()`

```js
db.productos.find().sort({ precio: 1 });     // ascendente
db.productos.find().sort({ precio: -1 });    // descendente
db.productos.find().sort({ categoria: 1, precio: -1 });   // múltiples campos
db.productos.find().limit(5);                // primeros 5
db.productos.find().skip(2).limit(3);        // página: salta 2, trae 3
```

#### `findOne`

Devuelve **un solo documento** (el primero que coincida) o `null`:

```js
db.productos.findOne({ nombre: "Monitor" });
db.productos.findOne();   // el primer documento sin filtro
```

### Consejos de `mongosh` para salida determinista

- **`--quiet`**: suprime el banner de bienvenida y el prompt; útil en scripts.
- **`--file`**: ejecuta un archivo JS y sale. Combinado con `--quiet` da salida limpia:

```bash
mongosh mongodb://localhost:27017/tienda --quiet --file script.js
```

- **`printjson`**: imprime un documento con formato legible. En un `forEach` para recorrer un cursor:

```js
db.productos.find().sort({ nombre: 1 }).forEach(d => printjson(d));
```

- **Pasar el nombre de la base como argumento** evita depender del prompt interactivo y hace los scripts reproducibles.
- **Hábitos de salida estable**: usa siempre `.sort()` explícito (un orden concreto) y proyección `_id: 0` para que la salida sea igual en cada ejecución. No imprimas el `ObjectId` generado en `insertOne` (cambia en cada corrida).
- Para evaluar una expresión sin archivo: `mongosh --quiet --eval "db.productos.countDocuments()"`.

## Ejemplos de código

### Bloque 1: arranque y conexión

```bash
podman run -d --name mongo -p 27017:27017 docker.io/library/mongo:7
mongosh mongodb://localhost:27017/tienda --quiet --file setup.js
```

### Bloque 2: insertar y contar

```js
db.productos.insertOne({ nombre: "Teclado Mecánico", precio: 45, stock: 5, categoria: "Periféricos" });
db.productos.insertMany([
  { nombre: "Auriculares", precio: 30, stock: 12, categoria: "Periféricos" },
  { nombre: "Webcam", precio: 60, stock: 4, categoria: "Periféricos" },
  { nombre: "Alfombrilla", precio: 8, stock: 60, categoria: "Accesorios" }
]);
print("Total de productos: " + db.productos.countDocuments());
```

### Bloque 3: consultas con filtro, proyección y orden

```js
db.productos.find({ categoria: "Periféricos" });
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 }).sort({ precio: -1 });
db.productos.find().skip(1).limit(2);
db.productos.findOne({ nombre: "Monitor" });
```

### Bloque 4: actualizar

```js
db.productos.updateOne({ nombre: "Ratón" }, { $set: { precio: 15 } });
db.productos.updateOne({ nombre: "Ratón" }, { $inc: { stock: -1 } });
db.productos.updateMany({ categoria: "Periféricos" }, { $inc: { precio: 5 } });
```

### Bloque 5: eliminar

```js
db.productos.deleteOne({ nombre: "Webcam" });
db.productos.deleteMany({ categoria: "Accesorios" });
db.productos.drop();
db.productos.countDocuments();
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/)
  - [Insert y Find](ejercicios/nivel-01-fundamentos/ejercicio-01-insert-y-find/)
  - [Find con Filtros](ejercicios/nivel-01-fundamentos/ejercicio-02-find-con-filtros/)
  - [Proyección](ejercicios/nivel-01-fundamentos/ejercicio-03-proyeccion/)
  - [Update](ejercicios/nivel-01-fundamentos/ejercicio-04-update/)
  - [Delete](ejercicios/nivel-01-fundamentos/ejercicio-05-delete/)
  - [Orden y Límite](ejercicios/nivel-01-fundamentos/ejercicio-06-orden-y-limit/)

## Errores comunes

1. **Olvidar que `find()` devuelve un cursor, no los datos**
   - **Causa**: en scripts se espera un array y se obtiene el cursor.
   - **Solución**: recórrelo con `.forEach(...)` o convierte con `.toArray()`; en el shell interactivo se imprime solo.

2. **Proyección que mezcla `1` y `0`**
   - **Causa**: `db.c.find({}, { nombre: 1, stock: 0 })` lanza error: no se pueden mezclar inclusiones y exclusiones.
   - **Solución**: usa solo inclusiones, o solo exclusiones. `_id: 0` es la única excepción que se puede combinar.

3. **Esperar que `findOne` devuelva un array**
   - **Causa**: `findOne` devuelve un documento o `null`, nunca una lista.
   - **Solución**: si quieres varios, usa `find`; usa `findOne` solo para buscar un único documento.

4. **Creer que sin `_id` el documento se rechaza**
   - **Causa**: MongoDB no rechaza nada: genera el `ObjectId` automáticamente.
   - **Solución**: si necesitas un id propio, pásalo en el `_id` antes de insertar y garantiza unicidad.

5. **`updateOne` solo cambia el primer documento y no avisa**
   - **Causa**: el acuse de `updateOne` incluye `modifiedCount: 1` aunque haya más coincidencias.
   - **Solución**: si quieres actualizar todos los que coinciden, usa `updateMany`.

6. **`updateOne` con `$inc` sobre un string**
   - **Causa**: `$inc` requiere un campo numérico; sobre texto devuelve error.
   - **Solución**: verifica el tipo con `findOne` y usa `$set` si el valor es texto.

7. **Fechas como strings en lugar de `ISODate`**
   - **Causa**: insertar `"2026-08-20"` guarda un string, y las consultas de rango de fechas fallan.
   - **Solución**: usa `new Date("2026-08-20")` o `ISODate(...)` y luego consulta con `$gte`/`$lt`.

8. **Salida no determinista en ejercicios**
   - **Causa**: `find()` sin orden devuelve los documentos en orden variable; el `_id` varía en cada inserción.
   - **Solución**: ordena con `.sort({ campo: 1 })` y usa proyección `_id: 0`; no imprimas `ObjectId` generados.

9. **Conectarse a `test` sin querer**
   - **Causa**: `mongosh` sin nombre de base usa la base `test` por defecto.
   - **Solución**: pasa siempre la base en la URI: `mongosh mongodb://localhost:27017/tienda`.

10. **Esperar `JOIN` entre colecciones en un `find`**
    - **Causa**: MongoDB no tiene `JOIN` en `find`; las relaciones requieren embebido o `$lookup` en agregación.
    - **Solución**: diseña el documento pensando en cómo se lee, o usa el *aggregation pipeline* (guías avanzadas).

## Recursos

- Documentación oficial de MongoDB: https://www.mongodb.com/docs/
- Manual de `mongosh`: https://www.mongodb.com/docs/mongodb-shell/
- Guía de CRUD: https://www.mongodb.com/docs/manual/crud/
- Tipos de datos BSON: https://www.mongodb.com/docs/manual/reference/bson-types/
- Operadores de actualización ($set, $inc...): https://www.mongodb.com/docs/manual/reference/operator/update/
- Imagen oficial de MongoDB en Docker Hub: https://hub.docker.com/_/mongo/
- Referencia de comandos del shell: https://www.mongodb.com/docs/manual/reference/method/
