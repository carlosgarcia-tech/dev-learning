# 05 — SQL Avanzado

## Objetivos

- [ ] Usar CTEs (Common Table Expressions)
- [ ] Crear y usar vistas
- [ ] Implementar índices
- [ ] Trabajar con transacciones
- [ ] Crear procedimientos almacenados
- [ ] Usar triggers
- [ ] Optimizar consultas

## Apuntes

### CTEs (Common Table Expressions)

```sql
-- CTE básico
WITH productos_caros AS (
    SELECT * FROM productos WHERE precio > 1000
)
SELECT * FROM productos_caros
ORDER BY precio DESC;

-- CTEs múltiples
WITH 
ventas_por_mes AS (
    SELECT 
        DATE_TRUNC('month', fecha) AS mes,
        SUM(total) AS total_ventas
    FROM pedidos
    GROUP BY DATE_TRUNC('month', fecha)
),
ventas_ordenadas AS (
    SELECT 
        mes,
        total_ventas,
        LAG(total_ventas) OVER (ORDER BY mes) AS mes_anterior
    FROM ventas_por_mes
)
SELECT 
    mes,
    total_ventas,
    mes_anterior,
    total_ventas - mes_anterior AS crecimiento
FROM ventas_ordenadas;

-- CTE recursiva (jerarquías)
WITH RECURSIVE empleados_jerarquia AS (
    -- Caso base
    SELECT 
        id, 
        nombre, 
        jefe_id,
        1 AS nivel
    FROM empleados
    WHERE jefe_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo
    SELECT 
        e.id, 
        e.nombre, 
        e.jefe_id,
        ej.nivel + 1 AS nivel
    FROM empleados e
    INNER JOIN empleados_jerarquia ej ON e.jefe_id = ej.id
)
SELECT * FROM empleados_jerarquia
ORDER BY nivel, nombre;
```

### Vistas

```sql
-- Crear vista
CREATE VIEW vista_clientes_activos AS
SELECT 
    id,
    nombre,
    email,
    telefono,
    fecha_registro
FROM clientes
WHERE activo = true;

-- Usar vista
SELECT * FROM vista_clientes_activos
ORDER BY fecha_registro DESC;

-- Vista materializada (PostgreSQL)
CREATE MATERIALIZED VIEW mv_ventas_por_mes AS
SELECT 
    DATE_TRUNC('month', fecha) AS mes,
    SUM(total) AS total_ventas,
    COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY DATE_TRUNC('month', fecha)
ORDER BY mes DESC;

-- Actualizar vista materializada
REFRESH MATERIALIZED VIEW mv_ventas_por_mes;
```

### Índices

```sql
-- Crear índice simple
CREATE INDEX idx_productos_nombre ON productos(nombre);

-- Índice compuesto
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha);

-- Índice único
CREATE UNIQUE INDEX idx_clientes_email ON clientes(email);

-- Índice parcial
CREATE INDEX idx_pedidos_activos ON pedidos(fecha) 
WHERE estado = 'activo';

-- Índice para búsqueda de texto
CREATE INDEX idx_productos_descripcion ON productos 
USING GIN (to_tsvector('spanish', descripcion));

-- Analizar consulta
EXPLAIN ANALYZE 
SELECT * FROM productos WHERE nombre LIKE '%laptop%';
```

### Transacciones

```sql
-- Iniciar transacción
BEGIN;

-- Realizar operaciones
INSERT INTO pedidos (cliente_id, total) VALUES (1, 100);
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad) 
VALUES (currval('pedidos_id_seq'), 1, 2);

-- Verificar
SELECT * FROM pedidos WHERE id = currval('pedidos_id_seq');

-- Confirmar
COMMIT;

-- O deshacer
ROLLBACK;

-- Savepoint
BEGIN;
INSERT INTO pedidos (cliente_id, total) VALUES (1, 100);
SAVEPOINT punto1;
UPDATE productos SET stock = stock - 2 WHERE id = 1;
ROLLBACK TO SAVEPOINT punto1;
COMMIT;
```

### Procedimientos Almacenados

```sql
-- Crear procedimiento (PostgreSQL)
CREATE OR REPLACE PROCEDURE actualizar_stock(
    producto_id INT,
    cantidad INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos 
    SET stock = stock - cantidad 
    WHERE id = producto_id;
    
    IF cantidad < 0 THEN
        RAISE EXCEPTION 'Cantidad no puede ser negativa';
    END IF;
    
    IF (SELECT stock FROM productos WHERE id = producto_id) < 0 THEN
        RAISE EXCEPTION 'Stock insuficiente';
    END IF;
END;
$$;

-- Llamar procedimiento
CALL actualizar_stock(1, 2);

-- Función almacenada
CREATE OR REPLACE FUNCTION calcular_total_pedido(
    pedido_id INT
)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
DECLARE
    total DECIMAL;
BEGIN
    SELECT SUM(p.precio * dp.cantidad)
    INTO total
    FROM detalle_pedido dp
    INNER JOIN productos p ON dp.producto_id = p.id
    WHERE dp.pedido_id = pedido_id;
    
    RETURN COALESCE(total, 0);
END;
$$;

-- Usar función
SELECT calcular_total_pedido(1);
```

### Triggers

```sql
-- Trigger para actualizar total del pedido
CREATE OR REPLACE FUNCTION actualizar_total_pedido()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE pedidos
    SET total = (
        SELECT COALESCE(SUM(p.precio * dp.cantidad), 0)
        FROM detalle_pedido dp
        INNER JOIN productos p ON dp.producto_id = p.id
        WHERE dp.pedido_id = NEW.pedido_id
    )
    WHERE id = NEW.pedido_id;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_actualizar_total
AFTER INSERT OR UPDATE OR DELETE ON detalle_pedido
FOR EACH ROW
EXECUTE FUNCTION actualizar_total_pedido();

-- Trigger para auditoría
CREATE TABLE auditoria_pedidos (
    id SERIAL PRIMARY KEY,
    pedido_id INT,
    accion VARCHAR(20),
    datos JSONB,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION auditar_pedido()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_pedidos (pedido_id, accion, datos)
        VALUES (NEW.id, 'INSERT', row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_pedidos (pedido_id, accion, datos)
        VALUES (OLD.id, 'UPDATE', jsonb_build_object(
            'old', row_to_json(OLD),
            'new', row_to_json(NEW)
        ));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_pedidos (pedido_id, accion, datos)
        VALUES (OLD.id, 'DELETE', row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$;

CREATE TRIGGER trigger_auditar_pedido
AFTER INSERT OR UPDATE OR DELETE ON pedidos
FOR EACH ROW
EXECUTE FUNCTION auditar_pedido();
```

## Ejercicios Relacionados

- [Ejercicio 13: CTEs](./ejercicios/nivel-03-intermedio/ejercicio-03-ctes/)
- [Ejercicio 14: Vistas](./ejercicios/nivel-03-intermedio/ejercicio-04-vistas/)
- [Ejercicio 18: Transacciones](./ejercicios/nivel-04-avanzado/ejercicio-03-transacciones/)
