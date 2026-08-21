CREATE TABLE logs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  mensaje VARCHAR(200) NOT NULL,
  fecha DATETIME NOT NULL
) ENGINE=InnoDB;

INSERT INTO logs (mensaje, fecha) VALUES
  ('Login exitoso',  '2024-01-01 10:00:00'),
  ('Error 404',       '2024-01-05 12:00:00'),
  ('Logout',         '2024-06-01 18:00:00'),
  ('Login exitoso',  '2024-06-15 09:00:00');
