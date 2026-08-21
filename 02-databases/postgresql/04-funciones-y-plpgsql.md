# 04 — Funciones y PL/pgSQL en PostgreSQL

## Objetivos

- [ ] Crear funciones en PL/pgSQL
- [ ] Usar variables y estructuras de control
- [ ] Implementar funciones con retorno
- [ ] Crear procedimientos almacenados
- [ ] Usar triggers
- [ ] Manejar excepciones

## Apuntes

### Funciones básicas (SQL)

```sql
CREATE OR REPLACE FUNCTION calcular_iva(precio DECIMAL)
RETURNS DECIMAL
AS $$
    SELECT precio * 1.21
$$ LANGUAGE SQL;

SELECT calcular_iva(100); -- 121.00
```

### Funciones PL/pgSQL

```sql
CREATE OR REPLACE FUNCTION obtener_cliente(p_id INT)
RETURNS TABLE(nombre VARCHAR, email VARCHAR, telefono VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.nombre, c.email, c.telefono
    FROM clientes c
    WHERE c.id = p_id;
END;
$$;
```

### Estructuras de control

```sql
CREATE OR REPLACE FUNCTION clasificar_precio(p_precio DECIMAL)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_precio < 100 THEN
        RETURN 'Económico';
    ELSIF p_precio < 500 THEN
        RETURN 'Medio';
    ELSIF p_precio < 1000 THEN
        RETURN 'Caro';
    ELSE
        RETURN 'Muy caro';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION estado_pedido_texto(p_estado VARCHAR)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN CASE p_estado
        WHEN 'pendiente' THEN 'Pedido pendiente de pago'
        WHEN 'pagado' THEN 'Pedido pagado, preparando envío'
        WHEN 'enviado' THEN 'Pedido en camino'
        WHEN 'entregado' THEN 'Pedido entregado'
        WHEN 'cancelado' THEN 'Pedido cancelado'
        ELSE 'Estado desconocido'
    END;
END;
$$;
```

### Procedimientos almacenados (PostgreSQL 11+)

```sql
CREATE OR REPLACE PROCEDURE actualizar_stock(
    p_producto_id INT,
    p_cantidad INT,
    INOUT p_stock_restante INT DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT stock INTO p_stock_restante FROM productos WHERE id = p_producto_id;

    IF p_stock_restante < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente (disponible: %, solicitado: %)',
            p_stock_restante, p_cantidad;
    END IF;

    UPDATE productos SET stock = stock - p_cantidad
    WHERE id = p_producto_id
    RETURNING stock INTO p_stock_restante;
END;
$$;

CALL actualizar_stock(1, 2, 0);
```

> `CALL` a un procedimiento con parámetro `INOUT` requiere pasar un valor
> inicial para ese parámetro (aquí `0`) al llamarlo.

### Triggers

```sql
CREATE OR REPLACE FUNCTION tr_actualizar_total_pedido()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE pedidos
    SET total = (
        SELECT COALESCE(SUM(cantidad * precio_unitario), 0)
        FROM detalle_pedido
        WHERE pedido_id = COALESCE(NEW.pedido_id, OLD.pedido_id)
    )
    WHERE id = COALESCE(NEW.pedido_id, OLD.pedido_id);

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trigger_actualizar_total
AFTER INSERT OR UPDATE OR DELETE ON detalle_pedido
FOR EACH ROW
EXECUTE FUNCTION tr_actualizar_total_pedido();
```

> En un trigger `AFTER ... OR DELETE`, `NEW` es `NULL` en un `DELETE`, así
> que el `RETURN` final debe ser `COALESCE(NEW, OLD)` (no simplemente
> `RETURN NEW`, que fallaría en el caso DELETE).

### Manejo de excepciones

```sql
CREATE OR REPLACE FUNCTION transferir_fondos(p_cliente_id INT, p_monto DECIMAL)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo_actual DECIMAL;
BEGIN
    SELECT saldo INTO v_saldo_actual FROM clientes WHERE id = p_cliente_id;

    IF NOT FOUND THEN
        RETURN 'Error: Cliente no encontrado';
    END IF;

    IF v_saldo_actual < p_monto THEN
        RAISE EXCEPTION 'Saldo insuficiente';
    END IF;

    UPDATE clientes SET saldo = saldo - p_monto WHERE id = p_cliente_id;

    RETURN 'Transferencia exitosa';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END;
$$;
```

> `SELECT ... INTO` no lanza error si no encuentra filas; deja la variable
> en `NULL` y activa `FOUND = false`. Comprobar `NOT FOUND` explícitamente
> (en vez de depender de una foreign key inexistente) es la forma correcta
> de detectar "cliente no encontrado".

## Ejercicios relacionados

- [Ejercicio 17: Funciones PL/pgSQL](./ejercicios/nivel-03-intermedio/ejercicio-05-funciones-plpgsql/)
- [Ejercicio 18: Transacciones](./ejercicios/nivel-03-intermedio/ejercicio-06-transacciones/)
- [Ejercicio 19: Triggers](./ejercicios/nivel-04-avanzado/ejercicio-01-triggers/)
- [Ejercicio 20: Stored Procedures](./ejercicios/nivel-04-avanzado/ejercicio-02-stored-procedures/)
