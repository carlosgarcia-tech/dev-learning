-- MYSQL-ONLY START
CREATE FULLTEXT INDEX idx_ft ON articulos (titulo, contenido);
SELECT titulo, contenido FROM articulos
WHERE MATCH(titulo, contenido) AGAINST('MySQL');
-- MYSQL-ONLY END

-- Fallback SQLite: busqueda LIKE equivalente
-- MYSQL-ONLY START
SELECT titulo, contenido FROM articulos
WHERE titulo LIKE '%MySQL%' OR contenido LIKE '%MySQL%';
-- MYSQL-ONLY END
