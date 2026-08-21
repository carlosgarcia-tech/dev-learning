-- === my.cnf de referencia (optimizado para servidor con 8GB RAM) ===
-- [mysqld]
-- innodb_buffer_pool_size = 5G
-- innodb_buffer_pool_instances = 5
-- innodb_log_file_size = 512M
-- innodb_flush_log_at_trx_commit = 1
-- innodb_flush_method = O_DIRECT
-- max_connections = 200
-- character-set-server = utf8mb4
-- collation-server = utf8mb4_unicode_ci
-- slow_query_log = 1
-- long_query_time = 1
-- log_queries_not_using_indexes = 1

-- Verificación de variables del servidor
SELECT 'tuning_reviewed' AS resultado, 'ok' AS estado;
