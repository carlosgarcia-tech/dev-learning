db.ventas.drop();
db.ventas.insertMany([
  { anio: 2024, mes: 1, vendedor: "ana", importe: 120 },
  { anio: 2024, mes: 2, vendedor: "luis", importe: 80 },
  { anio: 2024, mes: 3, vendedor: "carla", importe: 250 },
  { anio: 2024, mes: 3, vendedor: "ana", importe: 150 },
  { anio: 2024, mes: 4, vendedor: "marta", importe: 300 },
  { anio: 2025, mes: 1, vendedor: "luis", importe: 200 },
  { anio: 2025, mes: 2, vendedor: "carla", importe: 90 },
  { anio: 2025, mes: 3, vendedor: "marta", importe: 175 },
  { anio: 2025, mes: 3, vendedor: "ana", importe: 110 },
  { anio: 2025, mes: 4, vendedor: "luis", importe: 65 }
]);