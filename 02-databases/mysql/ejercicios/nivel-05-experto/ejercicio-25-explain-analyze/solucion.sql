-- MYSQL-ONLY START
EXPLAIN ANALYZE SELECT * FROM productos WHERE categoria = 'electronica';
SELECT id, nombre, precio FROM productos WHERE categoria = 'electronica' ORDER BY precio DESC;
-- MYSQL-ONLY END

-- Fallback SQLite: EXPLAIN QUERY PLAN + consulta de datos
-- MYSQL-ONLY START
EXPLAIN QUERY PLAN SELECT * FROM productos WHERE categoria = 'electronica';
SELECT id, nombre, precio FROM productos WHERE categoria = 'electronica' ORDER BY precio DESC;
-- MYSQL-ONLY END
