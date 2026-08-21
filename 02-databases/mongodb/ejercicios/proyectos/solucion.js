// solucion.js — Proyecto Final: Blog NoSQL con MongoDB
// Solución de referencia para las 12 operaciones del enunciado.
// Se ejecuta con: mongosh --file solucion.js blog_db

// ============================================================================
// 1. VALIDACIÓN DE ESQUEMAS
// ============================================================================
// El setup.js ya crea la colección usuarios con $jsonSchema.
// Aquí verificamos que la validación está activa.
print("=== 1. Validación de usuarios ===");
printjson(db.getCollectionInfos({ name: "usuarios" }).map(c => ({ name: c.name, validator: c.options.validator })));

// ============================================================================
// 2. CRUD BÁSICO
// ============================================================================

// 2.1 Insertar un nuevo usuario con rol autor
print("=== 2.1 Nuevo usuario ===");
db.usuarios.insertOne({
  _id: "u4",
  nombre: "Sara Díaz",
  email: "sara@mail.com",
  rol: "autor",
  creado: ISODate("2024-03-01T00:00:00Z")
});
printjson(db.usuarios.find({ _id: "u4" }, { _id: 0 }).toArray());

// 2.2 Insertar un nuevo post publicado con 2 tags y 1 comentario embebido
print("=== 2.2 Nuevo post ===");
db.posts.insertOne({
  _id: "p5",
  titulo: "Change Streams en MongoDB",
  contenido: "Los change streams permiten reaccionar a cambios en tiempo real en mongodb.",
  autor_id: "u4",
  categoria_id: "c3",
  tags: ["mongodb", "change-streams"],
  publicado: true,
  views: 5,
  creado: ISODate("2024-03-05T10:00:00Z"),
  comentarios: [
    { usuario: "Ana", texto: "¡Quiero probarlo!", fecha: ISODate("2024-03-06T08:00:00Z") }
  ]
});
printjson(db.posts.find({ _id: "p5" }, { _id: 0, titulo: 1, tags: 1 }).toArray());

// 2.3 Actualizar views de un post sumándole 10 ($inc)
print("=== 2.3 Incrementar views ===");
db.posts.updateOne({ _id: "p1" }, { $inc: { views: 10 } });
printjson(db.posts.find({ _id: "p1" }, { _id: 0, titulo: 1, views: 1 }).toArray());

// 2.4 Añadir un comentario nuevo a un post con $push
print("=== 2.4 Nuevo comentario ===");
db.posts.updateOne(
  { _id: "p1" },
  { $push: { comentarios: { usuario: "Sara", texto: "Gracias por el post.", fecha: ISODate("2024-03-10T08:00:00Z") } } }
);
printjson(db.posts.find({ _id: "p1" }, { _id: 0, titulo: 1, comentarios: 1 }).toArray());

// ============================================================================
// 3. AGREGACIONES PARA REPORTES
// ============================================================================

// 3.5 Top 3 posts por visitas
print("=== 5. Top 3 posts por visitas ===");
db.posts.aggregate([
  { $match: { publicado: true } },
  { $sort: { views: -1 } },
  { $limit: 3 },
  { $project: { _id: 0, titulo: 1, views: 1 } }
]).forEach(d => printjson(d));

// 3.6 Posts por autor (con $lookup para el nombre)
print("=== 6. Posts por autor ===");
db.posts.aggregate([
  {
    $lookup: {
      from: "usuarios",
      localField: "autor_id",
      foreignField: "_id",
      as: "autor"
    }
  },
  { $unwind: "$autor" },
  { $group: { _id: "$autor.nombre", num_posts: { $sum: 1 } } },
  { $project: { _id: 0, autor: "$_id", num_posts: 1 } },
  { $sort: { autor: 1 } }
]).forEach(d => printjson(d));

// 3.7 Posts por tag (con $unwind + $group)
print("=== 7. Posts por tag ===");
db.posts.aggregate([
  { $unwind: "$tags" },
  { $group: { _id: "$tags", num_posts: { $sum: 1 } } },
  { $project: { _id: 0, tag: "$_id", num_posts: 1 } },
  { $sort: { tag: 1 } }
]).forEach(d => printjson(d));

// 3.8 Comentarios totales por post (con $size, sin $unwind)
print("=== 8. Comentarios por post ===");
db.posts.aggregate([
  { $project: { _id: 0, titulo: 1, num_comentarios: { $size: { $ifNull: ["$comentarios", []] } } } },
  { $sort: { titulo: 1 } }
]).forEach(d => printjson(d));

// ============================================================================
// 4. ÍNDICES PARA BÚSQUEDA
// ============================================================================

// 4.9 Índice de texto sobre titulo y contenido
print("=== 9. Índice de texto ===");
print(db.posts.createIndex({ titulo: "text", contenido: "text" }));

// 4.10 Búsqueda $text $search "mongodb" con score
print("=== 10. Búsqueda $text 'mongodb' ===");
db.posts.find(
  { $text: { $search: "mongodb" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));

// 4.11 Índice ascendente sobre autor_id (para acelerar el $lookup)
print("=== 11. Índice sobre autor_id ===");
print(db.posts.createIndex({ autor_id: 1 }));

// ============================================================================
// 5. CHANGE STREAMS (requiere replica set)
// ============================================================================
print("=== 12. Change stream (requiere replica set) ===");

// Función segura: si no hay replica set, el watch() lanza y lo capturamos.
try {
  const cs = db.posts.watch();
  cs.disableBlockWarnings();
  db.posts.insertOne({
    _id: "p6",
    titulo: "Post desde change stream",
    contenido: "Este post se inserta para disparar un evento de change stream.",
    autor_id: "u1",
    categoria_id: "c1",
    tags: ["mongodb", "change-streams"],
    publicado: true,
    views: 0,
    creado: new Date(),
    comentarios: []
  });
  const ev = cs.next();
  printjson({ op: ev.operationType, titulo: ev.fullDocument.titulo });
  cs.close();
  print("change stream cerrado");
} catch (e) {
  // Sin replica set: el change stream no está disponible. Se valida la sintaxis.
  print("AVISO: change streams requiere replica set. Operación omitida en modo standalone.");
}

print("=== Solución completada ===");
