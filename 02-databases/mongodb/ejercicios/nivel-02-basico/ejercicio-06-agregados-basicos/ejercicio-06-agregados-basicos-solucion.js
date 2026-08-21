// 1. Número de ventas con importe > 100 (countDocuments con filtro)
print("Ventas con importe > 100: " + db.ventas.countDocuments({ importe: { $gt: 100 } }));

// 2. Ciudades distintas, en orden alfabético (distinct + sort)
printjson(db.ventas.distinct("ciudad").sort());

// 3. Vendedores distintos que venden en "Barcelona" (distinct con filtro)
printjson(db.ventas.distinct("vendedor", { ciudad: "Barcelona" }).sort());

// 4. Total de ventas (countDocuments)
print("Total de ventas: " + db.ventas.countDocuments());
