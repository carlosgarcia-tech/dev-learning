CREATE OR REPLACE PROCEDURE registrar_prestamo(
    p_usuario_id INT,
    p_libro_id INT,
    p_fecha_prestamo TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT cantidad INTO v_cantidad FROM libros WHERE id = p_libro_id FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Libro % no existe', p_libro_id;
    END IF;

    IF v_cantidad < 1 THEN
        RAISE EXCEPTION 'Sin ejemplares disponibles';
    END IF;

    -- El trigger trigger_validar_stock (BEFORE INSERT) ya descuenta el
    -- stock; aqui solo insertamos.
    INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo)
    VALUES (p_libro_id, p_usuario_id, p_fecha_prestamo);
END;
$$;
