CREATE INDEX idx_departamento ON empleados (departamento);
SELECT id, nombre, departamento FROM empleados WHERE departamento = 'IT' ORDER BY id;
