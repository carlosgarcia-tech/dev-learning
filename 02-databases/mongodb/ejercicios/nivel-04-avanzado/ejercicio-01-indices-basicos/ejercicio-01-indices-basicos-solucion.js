// 1. Índice ascendente sobre nombre (createIndex devuelve el nombre)
print(db.productos.createIndex({ nombre: 1 }));

// 2. Ver todos los índices: solo name y key (salida determinista)
printjson(db.productos.getIndexes().map(i => ({ name: i.name, key: i.key })));

// 3. Índice descendente sobre precio
print(db.productos.createIndex({ precio: -1 }));

// 4. Eliminar el índice nombre_1 y listar de nuevo
db.productos.dropIndex("nombre_1");
printjson(db.productos.getIndexes().map(i => ({ name: i.name, key: i.key })));