db.tareas.drop();
db.tareas.insertMany([
  { titulo: "Comprar leche", completada: false, prioridad: 1 },
  { titulo: "Estudiar Mongo", completada: true, prioridad: 3 },
  { titulo: "Hacer ejercicio", completada: false, prioridad: 2 },
  { titulo: "Leer un libro", completada: true, prioridad: 1 },
  { titulo: "Llamar al banco", completada: false, prioridad: 2 },
  { titulo: "Ordenar el escritorio", completada: true, prioridad: 1 }
]);