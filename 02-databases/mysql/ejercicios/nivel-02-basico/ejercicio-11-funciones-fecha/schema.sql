CREATE TABLE pedidos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cliente VARCHAR(100) NOT NULL,
  fecha DATE NOT NULL
) ENGINE=InnoDB;

INSERT INTO pedidos (cliente, fecha) VALUES
  ('Ana',   '2024-01-15'),
  ('Juan',  '2024-03-20'),
  ('Maria', '2024-06-10');
