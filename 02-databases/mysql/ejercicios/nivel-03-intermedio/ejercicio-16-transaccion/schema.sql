CREATE TABLE cuentas (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  titular VARCHAR(100) NOT NULL,
  saldo DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO cuentas (titular, saldo) VALUES
  ('Ana',  1000.00),
  ('Juan',  500.00),
  ('Maria', 200.00);
