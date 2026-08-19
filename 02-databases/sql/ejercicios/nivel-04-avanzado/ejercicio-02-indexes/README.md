# Ejercicio 20 — Índices

- **Nivel:** 4/5
- **Tema:** Avanzado de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crea índices para consultas frecuentes
2. Crea índices compuestos
3. Usa EXPLAIN para verificar uso de índices

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

SQLite no tiene índices GIN ni `to_tsvector` (la búsqueda de texto completo se hace con la extensión FTS5). El plan de ejecución se consulta con `EXPLAIN QUERY PLAN`.

```sql
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

-- Índice para búsqueda por nombre (FTS5 en SQLite)
CREATE INDEX idx_productos_nombre ON productos(nombre);

-- Verificar uso de índice
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE email = 'ana@email.com';

-- Verificar uso de índice compuesto
EXPLAIN QUERY PLAN
SELECT * FROM pedidos WHERE cliente_id = 1 AND fecha > '2024-01-01';
```

</details>
