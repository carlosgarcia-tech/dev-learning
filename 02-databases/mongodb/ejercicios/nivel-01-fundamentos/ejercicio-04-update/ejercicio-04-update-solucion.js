// 1. updateOne con $set: cambiar la categoría de "Tomate"
printjson(db.inventario.updateOne({ nombre: "Tomate" }, { $set: { categoria: "Frescos" } }));

// 2. updateMany con $inc: sumar 10 a la cantidad de los productos en stock
printjson(db.inventario.updateMany({ cantidad: { $gt: 0 } }, { $inc: { cantidad: 10 } }));

// 3. updateOne con $unset: eliminar el campo categoria de "Queso"
printjson(db.inventario.updateOne({ nombre: "Queso" }, { $unset: { categoria: "" } }));

// 4. updateMany con $set condicional: marcar como no activos los productos sin stock
printjson(db.inventario.updateMany({ cantidad: 0 }, { $set: { activo: false } }));

// Estado final de la colección
db.inventario.find({}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));