// 1. Empleados con salario > 3000 Y activos (operador $and explícito)
db.empleados.find({
  $and: [{ salario: { $gt: 3000 } }, { activo: true }]
}, { _id: 0 }).sort({ salario: 1 }).forEach(d => printjson(d));

// 2. Empleados del departamento "ventas" O con salario > 5000 (operador $or)
db.empleados.find({
  $or: [{ departamento: "ventas" }, { salario: { $gt: 5000 } }]
}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 3. Empleados cuyo salario NO sea mayor que 4000 (operador $not sobre $gt)
db.empleados.find({ salario: { $not: { $gt: 4000 } } }, { _id: 0 })
  .sort({ salario: 1 }).forEach(d => printjson(d));

// 4. Empleados que no estén inactivos NI sean de "rrhh" (operador $nor)
db.empleados.find({
  $nor: [{ activo: false }, { departamento: "rrhh" }]
}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));
