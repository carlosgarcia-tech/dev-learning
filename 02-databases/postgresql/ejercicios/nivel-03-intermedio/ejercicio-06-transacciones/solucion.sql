-- Transaccion simple de prestamo
BEGIN;
INSERT INTO prestamos (libro_id, usuario_id) VALUES (1, 1);
UPDATE libros SET cantidad = cantidad - 1 WHERE id = 1;
COMMIT;

-- Con verificacion de stock (aborta si no hay suficiente)
DO $$
DECLARE
    v_stock INT;
BEGIN
    SELECT cantidad INTO v_stock FROM libros WHERE id = 1 FOR UPDATE;
    IF v_stock < 1 THEN
        RAISE EXCEPTION 'Stock insuficiente';
    END IF;

    INSERT INTO prestamos (libro_id, usuario_id) VALUES (1, 2);
    UPDATE libros SET cantidad = cantidad - 1 WHERE id = 1;
END $$;

-- Con SAVEPOINT: revertir solo una parte de la transaccion
BEGIN;
INSERT INTO prestamos (libro_id, usuario_id) VALUES (2, 1);
SAVEPOINT antes_ajuste;
UPDATE libros SET cantidad = 0 WHERE id = 2; -- ajuste erroneo (por ejemplo, al libro equivocado)
ROLLBACK TO SAVEPOINT antes_ajuste;          -- deshace SOLO ese UPDATE, no el INSERT anterior
UPDATE libros SET cantidad = cantidad - 1 WHERE id = 2;   -- ajuste correcto
COMMIT;
