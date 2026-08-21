db.posts.drop();
db.posts.insertMany([
  {
    titulo: "Modelado embebido en MongoDB",
    autor: { nombre: "Ana", email: "ana@mail.com" },
    comentarios: [
      { usuario: "Luis", texto: "Muy claro, gracias." },
      { usuario: "Sara", texto: "¿Y cuándo conviene referenciar?" }
    ]
  },
  {
    titulo: "Transacciones en MongoDB",
    autor: { nombre: "Luis", email: "luis@mail.com" },
    comentarios: [
      { usuario: "Ana", texto: "Interesante." },
      { usuario: "Sara", texto: "Buen ejemplo." },
      { usuario: "Marta", texto: "Gracias por compartir." }
    ]
  },
  {
    titulo: "Indices y rendimiento",
    autor: { nombre: "Ana", email: "ana@mail.com" },
    comentarios: [
      { usuario: "Luis", texto: "Útil para producción." }
    ]
  }
]);
