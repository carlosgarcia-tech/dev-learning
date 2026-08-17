# Ejercicio 04 — Stored procedures

- **Nivel:** 4/5
- **Tema:** Funciones/procedimientos, `DO $$ ... $$`, `CREATE FUNCTION`
- **Tiempo estimado:** 25 min

## Enunciado

> ⚠️ Los stored procedures dependen del motor. Este ejercicio usa **PostgreSQL**. En SQLite no existe el lenguaje procedural: puedes probar la lógica equivalente con una consulta SQL normal.

Dada la tabla `productos`, crea en PostgreSQL:

1. Una **función** `aplicar_descuento(categoria_param TEXT, porcentaje REAL)` que multiplique el precio de todos los productos de esa categoría por `(1 - porcentaje/100)` y devuelva el número de filas afectadas (con `RETURN`).
2. Un **procedimiento/bloque anónimo** (`DO $$ ... $$`) que llame a la función para aplicar un 10% a la categoría `'ropa'` y verifique el cambio.

Resultado esperado: el precio del `'Camiseta'` pasa de `20.00` a `18.00`.

## Schema inicial

```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio REAL NOT NULL
);

INSERT INTO productos (id, nombre, categoria, precio) VALUES
    (1, 'Camiseta', 'ropa', 20.00),
    (2, 'Pantalon', 'ropa', 35.00),
    (3, 'Zapatillas', 'calzado', 60.00);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `CREATE FUNCTION nombre(p TEXT, pc REAL) RETURNS INTEGER AS $$ ... $$ LANGUAGE plpgsql;`
- Pista 2: Dentro de la función usa `UPDATE ... SET precio = precio * (1 - pc/100) WHERE categoria = p;` y `RETURN ...` con `FOUND` o un `RETURNS TABLE`.
- Pista 3: Para ejecutarla sin esperar retorno: `SELECT aplicar_descuento('ropa', 10);`.
- Pista 4: En SQLite, la alternativa es hacer el `UPDATE` directamente y comprobar con un `SELECT`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- PostgreSQL: función que aplica descuento y devuelve filas afectadas
CREATE OR REPLACE FUNCTION aplicar_descuento(
    categoria_param TEXT,
    porcentaje REAL
) RETURNS INTEGER AS $$
DECLARE
    filas INTEGER;
BEGIN
    UPDATE productos
    SET precio = precio * (1 - porcentaje / 100)
    WHERE categoria = categoria_param;

    GET DIAGNOSTICS filas = ROW_COUNT;
    RETURN filas;
END;
$$ LANGUAGE plpgsql;

-- Llamar a la función (devuelve 2)
SELECT aplicar_descuento('ropa', 10);

-- Verificación: Camiseta a 18.00
SELECT * FROM productos ORDER BY id;
````

</details>