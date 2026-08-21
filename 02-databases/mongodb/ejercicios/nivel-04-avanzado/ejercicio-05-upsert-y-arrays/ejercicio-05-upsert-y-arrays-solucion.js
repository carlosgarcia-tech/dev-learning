// 1. updateOne con upsert:true para un usuario nuevo (se crea el documento)
db.carritos.updateOne(
  { usuario: "marta" },
  { $set: { items: ["mochila"], total: 60 } },
  { upsert: true }
);
printjson(db.carritos.find({ usuario: "marta" }, { _id: 0 }).toArray());

// 2. $push: añadir un item al carrito de ana
db.carritos.updateOne({ usuario: "ana" }, { $push: { items: "zapatillas" } });
printjson(db.carritos.find({ usuario: "ana" }, { _id: 0 }).toArray());

// 3. $pull: quitar un item del carrito de luis
db.carritos.updateOne({ usuario: "luis" }, { $pull: { items: "reloj" } });
printjson(db.carritos.find({ usuario: "luis" }, { _id: 0 }).toArray());

// 4. $addToSet: añadir items únicos (no duplica)
db.carritos.updateOne(
  { usuario: "carla" },
  { $addToSet: { items: { $each: ["mochila", "mochila", "libro"] } } }
);
printjson(db.carritos.find({ usuario: "carla" }, { _id: 0 }).toArray());