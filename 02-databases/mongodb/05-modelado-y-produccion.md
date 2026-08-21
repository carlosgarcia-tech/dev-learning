# 05 — Modelado y producción

## Objetivos

- [ ] Decidir entre documentos embebidos y referencias según el patrón de acceso a los datos
- [ ] Aplicar los patrones de modelado más usados: embedding, referencing, subset, computed, bucket y polymorphic
- [ ] Entender el esquema flexible de MongoDB y cuándo imponer reglas con validación de esquemas
- [ ] Configurar un `validator` con `$jsonSchema` y `validationLevel`/`validationAction`
- [ ] Usar transacciones ACID multi-documento sobre replica sets
- [ ] Conocer la arquitectura de un replica set: primary, secondaries y elecciones
- [ ] Entender el sharding, los chunks y el shard key
- [ ] Consumir change streams para reaccionar a cambios en tiempo real
- [ ] Diferenciar Atlas Search del `$text` clásico
- [ ] Crear índices avanzados: TTL, text, geoespacial (`2dsphere`) y wildcard
- [ ] Asegurar un despliegue: autenticación, roles, TLS y control de acceso a la red
- [ ] Monitorear una instancia en producción y planificar migraciones

---

## 1. Modelado de datos: embebido vs referencias

A diferencia del modelo relacional, en MongoDB **no hay `JOIN` nativo barato**: el diseño del esquema depende de cómo se **lee** y se **escribe** la aplicación. La regla general es:

- **Embeber** cuando los datos se leen juntos, el subconjunto es acotado y pertenece a un solo documento padre (1 a pocos).
- **Referenciar** cuando los datos crecen sin límite, se actualizan por separado o se comparten entre muchos documentos.

```js
// Embebido: el comentario vive dentro del post
db.posts.insertOne({
  titulo: "Modelado en MongoDB",
  autor: { nombre: "Ana", email: "ana@mail.com" },
  comentarios: [
    { usuario: "Luis", texto: "Muy claro" },
    { usuario: "Sara", texto: "¿Y las referencias?" }
  ]
});

// Referencia: el comentario es un documento aparte que apunta al post
db.posts.insertOne({ _id: ObjectId("..."), titulo: "Modelado en MongoDB" });
db.comentarios.insertOne({ post_id: ObjectId("..."), usuario: "Luis", texto: "Muy claro" });
```

### Criterio de decisión

| Pregunta | Embeber si... | Referenciar si... |
|---|---|---|
| Cardinalidad | 1 a pocos (≤ ~100) | 1 a muchos o 1 a millones |
| Acceso | Siempre se lee junto | Se accede por separado |
| Actualización | Cambia poco o junto al padre | Se actualiza con frecuencia e independientemente |
| Tamaño del documento | Acotado (< 16 MB) | Crece sin límite |

> Límite físico: un documento BSON mide como máximo **16 MB**. No es un almacén para blobs; esos van en GridFS.

---

## 2. Patrones de diseño

### 2.1 Embedding

Subdocumentos que viven dentro del padre. Ideal para datos que se consultan juntos y tienen cardinalidad baja.

```js
db.usuarios.insertOne({
  nombre: "Ana",
  direccion: { calle: "Gran Vía 1", ciudad: "Madrid", cp: "28013" }
});
```

### 2.2 Referencing

Se guarda el `_id` del documento relacionado y se resuelve con `$lookup` o a nivel de aplicación. Útil para listas grandes o compartidas.

```js
db.pedidos.insertOne({ cliente_id: ObjectId("..."), total: 150 });
// Resolución con agregación
db.pedidos.aggregate([
  { $lookup: { from: "clientes", localField: "cliente_id", foreignField: "_id", as: "cliente" } },
  { $unwind: "$cliente" }
]);
```

### 2.3 Subset (subconjunto)

Se combina embedding y referencing: se embeben los datos **más usados** del documento relacionado y se referencia el resto.

```js
db.productos.insertOne({
  nombre: "Teclado",
  categoria: { _id: ObjectId("..."), nombre: "Periféricos" }  // subset embebido
  // la categoría completa vive en db.categorias
});
```

### 2.4 Computed (campo calculado)

Se persiste un valor derivado para evitar recalcularlo en cada consulta. Mejora el rendimiento de lectura a costa de mantenerlo actualizado en las escrituras.

```js
db.pedidos.insertOne({
  items: [{ producto: "raton", precio: 25, cantidad: 2 }],
  total: 50  // campo calculado, persistido
});
```

### 2.5 Bucket (agrupación por intervalos)

Se agrupan muchos documentos "finos" en un documento "contenedor" por intervalo (tiempo, categoría). Muy usado para series temporales (IoT, logs).

```js
// Un bucket por hora con todas sus mediciones embebidas
db.mediciones.insertOne({
  sensor: "temp-1",
  hora: ISODate("2024-01-01T10:00:00Z"),
  count: 3,
  valores: [20.1, 20.5, 20.3]
});
```

### 2.6 Polymorphic

Una sola colección guarda documentos con formas distintas, diferenciados por un campo discriminador (`tipo`).

```js
db.notificaciones.insertMany([
  { tipo: "email", destinatario: "ana@mail.com", asunto: "Hola" },
  { tipo: "push", dispositivo: "token-xyz", mensaje: "Hola" }
]);
// Consulta filtrando por tipo
db.notificaciones.find({ tipo: "email" });
```

---

## 3. Esquemas flexibles

MongoDB **no impone un esquema fijo**: una misma colección puede tener documentos con campos distintos. Esto da flexibilidad pero puede generar inconsistencias. Para mitigarlo se usa **validación de esquemas**.

```js
db.clientes.insertOne({ nombre: "Ana", edad: 30 });          // válido
db.clientes.insertOne({ nombre: "Luis" });                    // también se acepta sin validación
db.clientes.insertOne({ nombre: 123 });                       // tipo incorrecto sin validación
```

---

## 4. Validación de esquemas (`$jsonSchema`)

Se define un `validator` a nivel de colección que rechaza (o advierte) documentos que no cumplen.

```js
db.createCollection("clientes", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "edad", "email"],
      properties: {
        nombre: { bsonType: "string", description: "nombre obligatorio" },
        edad:   { bsonType: "int", minimum: 18, description: "edad adulta" },
        email:  { bsonType: "string", pattern: "@", description: "email con @" }
      }
    }
  },
  validationLevel: "strict",   // strict | moderate | off
  validationAction: "error"    // error | warn
});
```

- `validationLevel`: `strict` valida todos los documentos (insert y update); `moderate` solo los insert y los updates de documentos que ya cumplían.
- `validationAction`: `error` rechaza la operación; `warn` la admite pero registra una advertencia.

> En `mongosh`, un número literal es `double`; para validar `bsonType: "int"` usa `NumberInt(30)`. Un insert inválido lanza un error con `code` 121 (`DocumentValidationFailure`).

---

## 5. Transacciones ACID multi-documento

MongoDB soporta transacciones ACID sobre **varios documentos y colecciones** desde la versión 4.0 (replica set) y 4.2 (sharded cluster). Requieren una **sesión**.

```js
const session = db.getMongo().startSession();
try {
  session.startTransaction();
  const cuentas = session.getDatabase("ejercicios_db").cuentas;
  cuentas.updateOne({ numero: "A001" }, { $inc: { saldo: -100 } });
  cuentas.updateOne({ numero: "A002" }, { $inc: { saldo: 100 } });

  const origen = cuentas.findOne({ numero: "A001" });
  if (origen.saldo < 0) throw new Error("saldo insuficiente");

  session.commitTransaction();
} catch (e) {
  session.abortTransaction();
}
```

- `commitTransaction` persiste todos los cambios de forma atómica.
- `abortTransaction` los descarta y deja la colección como estaba.
- Las lecturas/escrituras dentro de la transacción deben pasar por `session.getDatabase(...)`.

> Coste: las transacciones multi-documento tienen overhead. No abuses de ellas para operaciones que se pueden resolver con un solo documento atómico (por ejemplo, mover dinero entre cuentas embebidas en el mismo documento).

---

## 6. Replica sets

Un **replica set** es un clúster de nodos MongoDB que mantienen la misma copia de los datos:

- **Primary**: el único nodo que acepta escrituras.
- **Secondaries**: réplicas que replican el *oplog* del primary y sirven lecturas (si se configura `readPreference`).
- **Elecciones**: si el primary cae, los secondaries votan para elegir uno nuevo (protocolo Raft).

```js
// Configuración mínima de un replica set (3 nodos para quórum)
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongo1:27017" },
    { _id: 1, host: "mongo2:27017" },
    { _id: 2, host: "mongo3:27017", arbiterOnly: true }
  ]
});
```

Las **transacciones** y los **change streams** requieren un replica set (o sharded cluster), porque dependen del oplog.

---

## 7. Sharding y chunks

El **sharding** distribuye los datos entre varios nodos (*shards*) para escalar horizontalmente. Cada shard es un replica set.

- **Shard key**: campo (o campos) que decide en qué shard vive cada documento. Es **inmutable** una vez definida y debe elegirse con cuidado.
- **Chunks**: rangos contiguos de valores de la shard key (~128 MB por defecto). El **balancer** mueve chunks entre shards para repartir la carga.
- **mongos**: router que recibe las consultas y las enruta al shard correcto.

```js
// Habilitar sharding en una base
sh.enableSharding("mi_db");
// Definir la shard key (requiere un índice previo)
db.productos.createIndex({ categoria: 1, _id: 1 });
sh.shardCollection("mi_db.productos", { categoria: 1, _id: 1 });
```

> Una mala shard key produce *jumbo chunks* o puntos calientes. Evita valores monótonos (como un timestamp ascendente) como shard key única.

---

## 8. Change streams

Los **change streams** permiten a una aplicación reaccionar a cambios (insert, update, delete, replace) en tiempo real, leyendo del oplog. Requieren replica set.

```js
const cs = db.eventos.watch();
cs.disableBlockWarnings();
db.eventos.insertOne({ tipo: "login", usuario: "ana" });
const ev = cs.next();
printjson({ op: ev.operationType, usuario: ev.fullDocument.usuario });
cs.close();
```

- Cada evento trae `operationType`, `fullDocument`, `ns` (namespace) y `resumeToken`.
- Se puede filtrar por tipo de operación: `db.eventos.watch([{ $match: { operationType: "insert" } }])`.
- Casos de uso: notificaciones, sincronización con Elasticsearch, invalidación de caché, auditoría.

---

## 9. Atlas Search

**Atlas Search** (basado en Lucene) ofrece búsqueda de texto avanzada (fuzzy, autocomplete, sinónimos) más allá del `$text` clásico. Está disponible en MongoDB Atlas y, desde la versión 8.0, también en servidores autogestionados mediante índices de búsqueda.

El `$text` clásico sigue siendo útil para búsquedas simples sin desplegar Lucene:

```js
db.libros.createIndex({ titulo: "text" });
db.libros.find(
  { $text: { $search: "aventura -espacio" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" } });
```

Atlas Search usa `$search` dentro de un pipeline de agregación y permite operadores como `fuzzy`, `phrase` y `autocomplete`.

---

## 10. Índices avanzados

Además de los índices simple y compuesto, MongoDB ofrece tipos especializados:

### TTL (Time To Live)

Elimina documentos automáticamente tras un número de segundos. Ideal para sesiones, cachés y logs efímeros.

```js
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 3600 });
// Los documentos con createdAt = hace >1h se borran solos
```

### Text

Índice de texto invertido para búsquedas con `$text`. Solo puede haber **un índice de texto por colección** (puede ser compuesto sobre varios campos).

```js
db.articulos.createIndex({ titulo: "text", contenido: "text" });
```

### Geoespacial (`2dsphere`)

Para consultas de proximidad y áreas sobre GeoJSON Points.

```js
db.locales.createIndex({ location: "2dsphere" });
db.locales.aggregate([{
  $geoNear: {
    near: { type: "Point", coordinates: [-3.703, 40.417] },
    distanceField: "dist", spherical: true
  }
}]);
```

### Wildcard

Indexa todos los subcampos de un campo dinámico, útil cuando el esquema varía.

```js
db.eventos.createIndex({ "atributos.$**": 1 });
```

> Coste: cada índice ralentiza las escrituras y ocupa espacio. Crea solo los que usen tus consultas y revisa los que no se usan con `$indexStats`.

---

## 11. Seguridad

### Autenticación y roles

MongoDB usa **SCRAM** por defecto. Se crean usuarios con roles sobre bases concretas.

```js
db.createUser({
  user: "appUser",
  pwd: passwordPrompt(),
  roles: [{ role: "readWrite", db: "mi_db" }]
});
```

Roles comunes: `read`, `readWrite`, `dbAdmin`, `userAdmin`, `clusterAdmin` (a nivel de servidor). Se recomienda **least privilege**: dar el rol mínimo necesario.

### TLS

En producción todo el tráfico debe ir cifrado con TLS. Se habilita en `mongod.conf`:

```yaml
net:
  tls:
    mode: requireTLS
    certificateKeyFile: /etc/mongo/server.pem
    CAFile: /etc/mongo/ca.pem
```

### Control de red

- Acepta conexiones solo desde IPs de confianza (`bindIp`).
- Usa *firewall* o *security groups* para limitar el acceso al puerto 27017.
- En Atlas, configura la *IP Access List* y la VPC peering.

---

## 12. Monitoreo

- `db.serverStatus()`: estado general del servidor (conexiones, memoria, opcounters).
- `db.collection.stats()`: tamaño, número de documentos e índices de una colección.
- `db.collection.explain("executionStats")`: plan de ejecución de una consulta y métricas (`nReturned`, `totalKeysExamined`, `totalDocsExamined`).
- `db.currentOp()`: operaciones en curso (para detectar consultas lentas).
- Profiler: `db.setProfilingLevel(1, { slowms: 100 })` registra operaciones que tardan más de 100 ms en `system.profile`.

En Atlas se usa el **Performance Advisor** y las métricas integradas. En entornos autogestionados, herramientas como **Prometheus + Grafana** con el MongoDB Exporter.

---

## 13. Migraciones

Para cambios de esquema en producción sin downtime:

1. **Expandir**: añade el nuevo campo sin tocar el viejo (los documentos antiguos lo omitem).
2. **Migrar gradualmente**: aplica el cambio en las escrituras nuevas y un job de fondo rellena los documentos antiguos.
3. **Contrair**: una vez todos los documentos tienen el nuevo campo, elimina el viejo.

```js
// Migración gradual: añade 'estado' en mayúsculas a partir del valor antiguo
db.pedidos.find({ estado: { $exists: false } }).forEach(doc => {
  db.pedidos.updateOne({ _id: doc._id }, { $set: { estado: (doc.estado_antiguo || "").toUpperCase() } });
});
```

Para mover datos entre clústeres se usan `mongodump`/`mongorestore`, `mongoexport`/`mongoimport` o herramientas de **live migration** de Atlas.

---

## 14. Rendimiento en producción

- **Indexa según tus consultas**, no por intuición. Verifica con `explain` que el índice se usa.
- **Evita el collection scan** en colecciones grandes: si `totalDocsExamined ≫ nReturned`, falta un índice.
- **Cuidado con los `$regex` con prefijo no anclado** (`/patrón/` sin `^`): no usan el índice. Usa `^patrón` o un índice de texto.
- **Limita los resultados** (`limit`) y pagina con `skip` solo en rangos cortos; para paginación profunda usa *cursor-based* (`_id > último_id`).
- **Proyección** para traer solo los campos necesarios y reducir el tráfico de red.
- **Revisa el tamaño de los documentos**: documentos muy grandes (cercanos a 16 MB) penalizan la memoria y las escrituras.
- **Write concern**: `w: 1` (rápido, un nodo) vs `w: "majority"` (durabilidad, confirmado en la mayoría del replica set).
- **Read preference**: dirige lecturas a secondaries solo cuando toleres lecturas *eventualmente consistentes*.

```js
// Write concern duradero
db.cuentas.insertOne({ numero: "A003", saldo: 200 }, { writeConcern: { w: "majority", j: true } });
```

---

## Resumen

| Concepto | Cuándo aplicarlo |
|---|---|
| Embebido | Datos leídos juntos, cardinalidad baja |
| Referencia | Datos grandes, compartidos, que cambian solos |
| Subset | Lo más leído embebido + referencia al resto |
| Validación de esquemas | Cuando la flexibilidad genera inconsistencias |
| Transacciones | Operaciones multi-documento que deben ser atómicas |
| Replica set | Alta disponibilidad y base para transacciones/change streams |
| Sharding | Escalar horizontalmente más allá de un nodo |
| Change streams | Reaccionar a cambios en tiempo real |
| TTL | Documentos efímeros (sesiones, logs) |
| `$jsonSchema` | Imponer reglas de forma declarativa |
