CREATE TABLE articulos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(200) NOT NULL,
  contenido TEXT NOT NULL
) ENGINE=InnoDB;

INSERT INTO articulos (titulo, contenido) VALUES
  ('Aprende MySQL', 'Tutorial completo de MySQL para principiantes y avanzados'),
  ('PostgreSQL vs MySQL', 'Comparacion de los dos motores de bases de datos'),
  ('PHP y Laravel', 'Desarrollo web con PHP y el framework Laravel');
