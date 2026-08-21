CREATE TABLE empleados (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  departamento VARCHAR(50) NOT NULL,
  salario DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO empleados (nombre, departamento, salario) VALUES
  ('Ana Torres',   'Ventas',  2500.00),
  ('Juan Ruiz',    'Ventas',  3200.00),
  ('Marcos Diaz',  'Ventas',  3200.00),
  ('Maria Lopez',  'IT',      4000.00),
  ('Carlos Mena',  'IT',      3500.00),
  ('Pedro Rios',   'IT',      4000.00);
