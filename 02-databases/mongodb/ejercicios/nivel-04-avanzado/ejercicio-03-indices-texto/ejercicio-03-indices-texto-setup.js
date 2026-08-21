db.articulos.drop();
db.articulos.insertMany([
  { titulo: "Introducción a MongoDB", contenido: "MongoDB es una base de datos NoSQL. Aprende los fundamentos de mongo y su shell." },
  { titulo: "Búsqueda de texto en MongoDB", contenido: "Los índices de texto permiten buscar palabras mongo clave en documentos de texto." },
  { titulo: "Índices y rendimiento", contenido: "Un buen índice acelera las consultas y reduce el tiempo de búsqueda en grandes colecciones." },
  { titulo: "MongoDB con Node.js", contenido: "Combina MongoDB con Node.js y express para construir aplicaciones web. Una base de datos mongo bien indexada es rápida." },
  { titulo: "Geolocalización espacial", contenido: "MongoDB incluye consultas geoespaciales con índices 2dsphere para buscar puntos cercanos." }
]);