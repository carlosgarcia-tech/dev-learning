-- Genera algo de actividad de lectura para tener estadisticas que analizar
SELECT * FROM prestamos WHERE usuario_id = 1;
SELECT * FROM libros WHERE genero = 'Fantasia';

-- Tablas con muchos seq_scan y pocos index_scan (candidatas a indexar)
-- Nota: pg_stat_user_tables usa "relname", no "tablename" (ese nombre de
-- columna es de pg_tables/pg_indexes, una familia de vistas distinta).
SELECT schemaname, relname AS tabla, seq_scan, seq_tup_read, idx_scan
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;

-- Indices existentes que nunca se han usado
SELECT schemaname, relname AS tabla, indexrelname AS indice, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY relname;

-- Ejemplo de indice sugerido a partir del analisis anterior
CREATE INDEX IF NOT EXISTS idx_libros_genero ON libros(genero);
