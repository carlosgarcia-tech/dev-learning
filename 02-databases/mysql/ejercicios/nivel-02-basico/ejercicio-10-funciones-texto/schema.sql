CREATE TABLE usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

INSERT INTO usuarios (nombre, email) VALUES
  ('Ana Garcia', 'ANA@MAIL.COM'),
  ('Juan Perez', 'JUAN@MAIL.COM');
