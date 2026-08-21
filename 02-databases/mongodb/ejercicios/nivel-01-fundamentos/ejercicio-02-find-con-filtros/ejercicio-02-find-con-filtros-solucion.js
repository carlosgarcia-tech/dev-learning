// 1. Usuarios de Madrid (filtro por igualdad)
db.usuarios.find({ ciudad: "Madrid" }, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 2. Usuarios que NO son de Madrid ($ne)
db.usuarios.find({ ciudad: { $ne: "Madrid" } }, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 3. Usuarios activos y con 30 años o más (filtro múltiple)
db.usuarios.find({ activo: true, edad: { $gte: 30 } }, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 4. Recuento de usuarios con 30 años o más (countDocuments con filtro)
print("Usuarios con edad >= 30: " + db.usuarios.countDocuments({ edad: { $gte: 30 } }));