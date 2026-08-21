db.usuarios.drop();
db.usuarios.insertMany([
  { nombre: "Ana", edad: 30, ciudad: "Madrid", activo: true },
  { nombre: "Luis", edad: 45, ciudad: "Barcelona", activo: true },
  { nombre: "Marta", edad: 25, ciudad: "Madrid", activo: false },
  { nombre: "Pedro", edad: 50, ciudad: "Sevilla", activo: true },
  { nombre: "Sara", edad: 35, ciudad: "Barcelona", activo: false },
  { nombre: "Jorge", edad: 28, ciudad: "Madrid", activo: true }
]);