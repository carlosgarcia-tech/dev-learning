# Ejercicio 19 — Stored Procedure

- **Nivel:** 4/5
- **Tema:** Avanzado de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL**: los stored procedures son específicos de MySQL (sintaxis
> `DELIMITER`, `CREATE PROCEDURE`, `BEGIN...END`). El `test.sh` requiere MySQL para
> validar este ejercicio.

## Enunciado

La tabla `productos` ya existe con datos. Crea un stored procedure que devuelva
productos por categoría.

1. Crea un stored procedure `sp_productos_por_categoria` que reciba un parámetro
   `p_categoria VARCHAR(50)` y devuelva `id`, `nombre`, `precio` de los productos
   de esa categoría, ordenados por `precio DESC`.
2. Llama al procedure con `CALL sp_productos_por_categoria('electronica');`

## Requisitos

- [ ] Usas `DELIMITER`, `CREATE PROCEDURE` con parámetro `IN`, `BEGIN...END`
- [ ] El procedure se llama con `CALL`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cambia el delimitador con `DELIMITER //` antes del `CREATE PROCEDURE`.
- El parámetro se declara como `IN p_categoria VARCHAR(50)`.
- Dentro del `BEGIN...END` va el `SELECT`.
- Restaura el delimitador con `DELIMITER ;` después.
- Llama con `CALL sp_productos_por_categoria('electronica');`

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
DELIMITER //
CREATE PROCEDURE sp_productos_por_categoria(IN p_categoria VARCHAR(50))
BEGIN
    SELECT id, nombre, precio
    FROM productos
    WHERE categoria = p_categoria
    ORDER BY precio DESC;
END //
DELIMITER ;

CALL sp_productos_por_categoria('electronica');
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-04-avanzado/ejercicio-19-stored-procedure
bash test.sh
```
