db.empleados.drop();
db.empleados.insertMany([
  { nombre: "ana", salario: 6200, bono: 500 },
  { nombre: "luis", salario: 4800, bono: 300 },
  { nombre: "carla", salario: 3500 },
  { nombre: "diego", salario: 4200, bono: 200 },
  { nombre: "eva", salario: 2800 },
  { nombre: "fran", salario: 5400, bono: 400 }
]);