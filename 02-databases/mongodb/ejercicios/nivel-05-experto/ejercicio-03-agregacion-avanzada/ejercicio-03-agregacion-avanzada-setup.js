db.ventas.drop();
db.ventas.insertMany([
  { fecha: "2024-01-05", vendedor: "Ana", importe: 150, categoria: "electronica" },
  { fecha: "2024-01-12", vendedor: "Luis", importe: 40, categoria: "ropa" },
  { fecha: "2024-02-03", vendedor: "Ana", importe: 300, categoria: "hogar" },
  { fecha: "2024-02-18", vendedor: "Sara", importe: 90, categoria: "ropa" },
  { fecha: "2024-03-01", vendedor: "Luis", importe: 250, categoria: "electronica" },
  { fecha: "2024-03-22", vendedor: "Sara", importe: 120, categoria: "hogar" },
  { fecha: "2024-04-09", vendedor: "Ana", importe: 60, categoria: "ropa" },
  { fecha: "2024-04-27", vendedor: "Luis", importe: 500, categoria: "electronica" },
  { fecha: "2024-05-14", vendedor: "Sara", importe: 80, categoria: "hogar" },
  { fecha: "2024-05-30", vendedor: "Ana", importe: 200, categoria: "electronica" }
]);
