CREATE TABLE libros (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  autor VARCHAR(100) NOT NULL,
  anio YEAR
) ENGINE=InnoDB;

INSERT INTO libros (nombre, autor, anio) VALUES
  ('Cien anos de soledad', 'Gabriel Garcia Marquez', 1967),
  ('Rayuela', 'Julio Cortazar', 1963),
  ('El tunel', 'Ernesto Sabato', 1948);
