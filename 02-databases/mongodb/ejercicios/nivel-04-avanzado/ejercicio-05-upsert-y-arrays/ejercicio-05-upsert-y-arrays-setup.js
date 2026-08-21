db.carritos.drop();
db.carritos.insertMany([
  { usuario: "ana", items: ["camisa", "gorra"], total: 40 },
  { usuario: "luis", items: ["reloj"], total: 120 },
  { usuario: "carla", items: [], total: 0 }
]);