CREATE TABLE empleados (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  departamento VARCHAR(50) NOT NULL,
  salario DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO empleados (nombre, departamento, salario) VALUES
  ('Ana Torres',   'Ventas',  2500.00),
  ('Juan Ruiz',    'IT',      4000.00),
  ('Maria Lopez',  'IT',      3500.00),
  ('Carlos Mena',  'RRHH',    2800.00),
  ('Lucia Perez',  'Ventas',  2900.00);
