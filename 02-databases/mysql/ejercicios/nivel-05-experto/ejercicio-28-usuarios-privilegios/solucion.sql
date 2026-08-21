-- Creación de usuarios con privilegios mínimos
CREATE USER 'app_reader'@'localhost' IDENTIFIED BY 'Reader123!';
CREATE USER 'app_writer'@'localhost' IDENTIFIED BY 'Writer123!';

GRANT SELECT ON *.* TO 'app_reader'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'app_writer'@'localhost';

-- Verificación
SELECT 'users_created' AS resultado, 'ok' AS estado;
