CREATE TABLE pedidos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  codigo CHAR(6) NOT NULL,
  cliente VARCHAR(80) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  estado ENUM('pendiente','pagado','enviado') DEFAULT 'pendiente',
  notas TEXT,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO pedidos (codigo, cliente, total, estado, notas) VALUES
  ('P00001', 'Ana', 150.75, 'pagado', 'Entrega urgente'),
  ('P00002', 'Juan', 89.90, DEFAULT, NULL);

SELECT id, codigo, cliente, total, estado FROM pedidos ORDER BY id;
