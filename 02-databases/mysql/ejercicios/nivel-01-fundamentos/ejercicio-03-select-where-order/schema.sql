CREATE TABLE empleados (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  departamento VARCHAR(50) NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

INSERT INTO empleados (nombre, departamento, salario, activo) VALUES
  ('Ana Torres',    'Ventas',     2500.00, 1),
  ('Juan Ruiz',      'Ventas',     3200.00, 1),
  ('Maria Lopez',    'IT',         4000.00, 1),
  ('Carlos Mena',    'IT',         3500.00, 0),
  ('Lucia Perez',   'RRHH',       2800.00, 1),
  ('Marcos Diaz',   'Ventas',     2900.00, 1),
  ('Marta Soto',     'RRHH',       3100.00, 1),
  ('Pedro Rios',    'IT',         4200.00, 0);
