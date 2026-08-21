-- MYSQL-ONLY START
CREATE TABLE ventas_particionadas (
  id INT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  producto VARCHAR(100) NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id, fecha)
) ENGINE=InnoDB
PARTITION BY RANGE (YEAR(fecha)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION pmax  VALUES LESS THAN MAXVALUE
);

INSERT INTO ventas_particionadas (fecha, producto, monto) VALUES
  ('2023-06-15', 'Mouse',   25.00),
  ('2024-03-20', 'Teclado', 45.00),
  ('2025-01-10', 'Monitor', 300.00);

SELECT id, fecha, producto, monto FROM ventas_particionadas ORDER BY id;
-- MYSQL-ONLY END

-- Fallback SQLite: tabla normal sin particionamiento (mismos datos y consulta)
-- MYSQL-ONLY START
CREATE TABLE ventas_particionadas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fecha DATE NOT NULL,
  producto VARCHAR(100) NOT NULL,
  monto DECIMAL(10,2) NOT NULL
);

INSERT INTO ventas_particionadas (fecha, producto, monto) VALUES
  ('2023-06-15', 'Mouse',   25.00),
  ('2024-03-20', 'Teclado', 45.00),
  ('2025-01-10', 'Monitor', 300.00);

SELECT id, fecha, producto, monto FROM ventas_particionadas ORDER BY id;
-- MYSQL-ONLY END
