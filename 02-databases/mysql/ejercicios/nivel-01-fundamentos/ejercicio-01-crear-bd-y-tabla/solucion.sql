-- Solución: crear la tabla usuarios, insertar dos filas y consultarlas.

CREATE TABLE usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO usuarios (nombre, email) VALUES
  ('Ana', 'ana@mail.com'),
  ('Juan', 'juan@mail.com');

SELECT id, nombre, email FROM usuarios ORDER BY id;
