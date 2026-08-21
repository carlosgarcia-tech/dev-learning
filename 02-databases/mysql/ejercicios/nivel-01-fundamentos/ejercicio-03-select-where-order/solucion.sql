(SELECT id, nombre, departamento, salario FROM empleados
 WHERE departamento = 'Ventas' ORDER BY salario DESC)
UNION ALL
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE salario > 3000 ORDER BY nombre)
UNION ALL
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE nombre LIKE 'M%' ORDER BY id)
UNION ALL
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE activo = 1 ORDER BY departamento, nombre);
