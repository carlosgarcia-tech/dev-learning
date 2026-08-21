CREATE TABLE clientes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

INSERT INTO clientes (nombre, email) VALUES
  ('Ana Perez', 'ana@mail.com'),
  ('Juan Lopez', 'juan@mail.com'),
  ('Maria Ruiz', 'maria@mail.com');
