// 1. Borrar una tarea concreta con deleteOne
printjson(db.tareas.deleteOne({ titulo: "Llamar al banco" }));

// 2. Borrar todas las tareas completadas con deleteMany
printjson(db.tareas.deleteMany({ completada: true }));

// 3. Recuento de tareas restantes y estado de la colección
print("Tareas restantes: " + db.tareas.countDocuments());
db.tareas.find({}, { _id: 0 }).sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Drop de una colección temporal y verificación
db.temporal.insertOne({ nota: "temporal" });
print("Colección temporal existe (antes del drop): " + db.getCollectionNames().includes("temporal"));
db.temporal.drop();
print("Colección temporal existe (después del drop): " + db.getCollectionNames().includes("temporal"));