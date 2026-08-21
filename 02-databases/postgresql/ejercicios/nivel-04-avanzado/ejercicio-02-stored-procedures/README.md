# Ejercicio 02 — Stored Procedures

- **Nivel:** 4/5
- **Tema:** Avanzado de PostgreSQL
- **Tiempo estimado:** 35 minutos

## Enunciado

1. Procedimiento para registrar un préstamo completo (valida stock, inserta, descuenta)
2. Manejo de errores con ROLLBACK automático si algo falla

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

Un `PROCEDURE` no puede llevar `BEGIN ... EXCEPTION ... COMMIT/ROLLBACK` explícitos en su cuerpo cuando se invoca dentro de la transacción de `psql -f` (la transacción la controla quien llama). Si `RAISE EXCEPTION` se dispara, PostgreSQL ya revierte automáticamente los cambios de esa sentencia/transacción, así que no hace falta un `ROLLBACK` manual dentro del procedimiento.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
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

    INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo)
    VALUES (p_libro_id, p_usuario_id, p_fecha_prestamo);

    UPDATE libros SET cantidad = cantidad - 1 WHERE id = p_libro_id;
END;
$$;

CALL registrar_prestamo(1, 1, CURRENT_TIMESTAMP);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-04-avanzado/ejercicio-02-stored-procedures
bash test.sh
```
