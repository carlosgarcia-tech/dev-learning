-- Índice simple
CREATE INDEX idx_clientes_email ON clientes(email);

-- Índice compuesto
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha);

-- Índice parcial (solo para activos)
CREATE INDEX idx_clientes_activos ON clientes(email)
WHERE activo = 1;

-- Índice con condiciones
CREATE INDEX idx_pedidos_monto ON pedidos(total)
WHERE estado = 'pagado';

-- Índice para búsqueda por nombre.
-- SQLite no tiene GIN ni to_tsvector de PostgreSQL; la alternativa de
-- búsqueda de texto completo es la extensión FTS5.
CREATE INDEX idx_productos_nombre ON productos(nombre);

-- Verificar uso de índice simple (búsqueda por email)
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE email = 'ana@email.com';

-- Verificar uso de índice compuesto (cliente + fecha)
EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE cliente_id = 1 AND fecha > '2024-01-01';