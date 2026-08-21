// 1. Post completo con sus comentarios (doc embebido, _id:0)
printjson(db.posts.findOne(
  { titulo: "Modelado embebido en MongoDB" },
  { _id: 0, titulo: 1, autor: 1, comentarios: 1 }
));

// 2. Posts de un autor (dot notation)
db.posts.find(
  { "autor.email": "ana@mail.com" },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. $push un comentario nuevo a un post
db.posts.updateOne(
  { titulo: "Modelado embebido en MongoDB" },
  { $push: { comentarios: { usuario: "Marta", texto: "¿Dónde hay más ejemplos?" } } }
);
printjson(db.posts.findOne(
  { titulo: "Modelado embebido en MongoDB" },
  { _id: 0, titulo: 1, comentarios: 1 }
));

// 4. Proyección mostrando solo título y comentarios
db.posts.find(
  {},
  { _id: 0, titulo: 1, comentarios: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
