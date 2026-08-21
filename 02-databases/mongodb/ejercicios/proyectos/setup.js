// setup.js — Proyecto Final: Blog NoSQL con MongoDB
// Crea la base blog_db, define validaciones e inserta datos de ejemplo.
// Se ejecuta con: mongosh --file setup.js blog_db

// Limpieza inicial
db.usuarios.drop();
db.categorias.drop();
db.posts.drop();

// 1. Colección usuarios con validación $jsonSchema
db.createCollection("usuarios", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "email", "rol"],
      properties: {
        nombre: { bsonType: "string", description: "nombre obligatorio" },
        email: { bsonType: "string", pattern: "@", description: "email con @" },
        rol: { bsonType: "string", enum: ["autor", "editor", "admin"], description: "rol válido" },
        creado: { bsonType: "date", description: "fecha de alta" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});

// Categorías (colección de referencia)
db.categorias.insertMany([
  { _id: "c1", nombre: "Tecnología", slug: "tecnologia" },
  { _id: "c2", nombre: "Opinión", slug: "opinion" },
  { _id: "c3", nombre: "Tutoriales", slug: "tutoriales" }
]);

// Usuarios
db.usuarios.insertMany([
  { _id: "u1", nombre: "Ana García", email: "ana@mail.com", rol: "autor", creado: ISODate("2024-01-01T00:00:00Z") },
  { _id: "u2", nombre: "Luis López", email: "luis@mail.com", rol: "autor", creado: ISODate("2024-01-05T00:00:00Z") },
  { _id: "u3", nombre: "Marta Ruiz", email: "marta@mail.com", rol: "editor", creado: ISODate("2024-01-10T00:00:00Z") }
]);

// Posts (comentarios embebidos; categoría referenciada)
db.posts.insertMany([
  {
    _id: "p1",
    titulo: "Introducción a MongoDB",
    contenido: "MongoDB es una base de datos de documentos NoSQL. Aprende mongodb desde cero.",
    autor_id: "u1",
    categoria_id: "c1",
    tags: ["mongodb", "nosql", "base-de-datos"],
    publicado: true,
    views: 150,
    creado: ISODate("2024-01-15T10:00:00Z"),
    comentarios: [
      { usuario: "Luis", texto: "¡Muy bueno!", fecha: ISODate("2024-01-16T08:00:00Z") },
      { usuario: "Marta", texto: "Claro y útil.", fecha: ISODate("2024-01-17T09:00:00Z") }
    ]
  },
  {
    _id: "p2",
    titulo: "Agregaciones avanzadas",
    contenido: "El aggregation pipeline de mongodb permite transformar documentos con etapas.",
    autor_id: "u2",
    categoria_id: "c3",
    tags: ["mongodb", "agregacion"],
    publicado: true,
    views: 90,
    creado: ISODate("2024-02-01T10:00:00Z"),
    comentarios: [
      { usuario: "Ana", texto: "Gran tutorial.", fecha: ISODate("2024-02-02T08:00:00Z") }
    ]
  },
  {
    _id: "p3",
    titulo: "Índices y rendimiento",
    contenido: "Los índices aceleran las consultas en mongodb y otras bases de datos.",
    autor_id: "u1",
    categoria_id: "c1",
    tags: ["mongodb", "rendimiento", "indices"],
    publicado: true,
    views: 220,
    creado: ISODate("2024-02-10T10:00:00Z"),
    comentarios: []
  },
  {
    _id: "p4",
    titulo: "Opinión sobre NoSQL",
    contenido: "Reflexiones sobre el modelo NoSQL frente a SQL.",
    autor_id: "u3",
    categoria_id: "c2",
    tags: ["nosql", "opinion"],
    publicado: false,
    views: 10,
    creado: ISODate("2024-02-15T10:00:00Z"),
    comentarios: [
      { usuario: "Luis", texto: "Interesante.", fecha: ISODate("2024-02-16T08:00:00Z") }
    ]
  }
]);

print("setup: blog_db cargada con " + db.usuarios.countDocuments() + " usuarios, " +
      db.categorias.countDocuments() + " categorías y " + db.posts.countDocuments() + " posts");
