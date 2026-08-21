// 1. Índice compuesto: anio ascendente + mes descendente
print(db.ventas.createIndex({ anio: 1, mes: -1 }));

// 2. Índice compuesto: vendedor ascendente + importe descendente
print(db.ventas.createIndex({ vendedor: 1, importe: -1 }));

// 3. Ver todos los índices: solo name y key
printjson(db.ventas.getIndexes().map(i => ({ name: i.name, key: i.key })));

// 4. Explain de una consulta sobre (anio, mes): solo campos estables
const e = db.ventas.find({ anio: 2024, mes: 3 }).explain("executionStats");
printjson({
  nReturned: e.executionStats.nReturned,
  totalKeysExamined: e.executionStats.totalKeysExamined,
  totalDocsExamined: e.executionStats.totalDocsExamined
});