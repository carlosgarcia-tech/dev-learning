-- MYSQL-ONLY START
SET GLOBAL event_scheduler = ON;
CREATE EVENT ev_limpiar_logs
ON SCHEDULE EVERY 1 HOUR
DO
  DELETE FROM logs WHERE fecha < DATE_SUB(NOW(), INTERVAL 7 DAY);
SELECT event_name FROM information_schema.events;
SELECT id, mensaje, fecha FROM logs ORDER BY id;
-- MYSQL-ONLY END

-- Fallback SQLite: validar solo la consulta de datos (sin evento)
-- MYSQL-ONLY START
SELECT id, mensaje, fecha FROM logs ORDER BY id;
-- MYSQL-ONLY END
