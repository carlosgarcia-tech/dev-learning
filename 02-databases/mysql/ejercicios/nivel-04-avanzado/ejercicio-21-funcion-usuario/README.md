# Ejercicio 21 — Función de usuario

- **Nivel:** 4/5
- **Tema:** Avanzado de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL**: las funciones definidas por usuario (UDF) son específicas
> de MySQL. El `test.sh` requiere MySQL para validar este ejercicio.

## Enunciado

La tabla `productos` ya existe con datos. Crea una función que calcule el precio con IVA.

1. Crea una función `fn_precio_con_iva` que reciba un `DECIMAL(10,2)` y devuelva el
   precio multiplicado por 1.21 (IVA del 21%).
2. Usa la función en una consulta: muestra `nombre`, `precio` y `fn_precio_con_iva(precio)`
   ordenados por `id`.

## Requisitos

- [ ] Usas `CREATE FUNCTION` con `RETURNS` y `DETERMINISTIC`
- [ ] La función se usa dentro de un `SELECT`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Antes de crear la función, puede que necesites: `SET GLOBAL log_bin_trust_function_creators = 1;`
- `CREATE FUNCTION fn(p DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC RETURN p * 1.21;`
- Luego: `SELECT nombre, precio, fn_precio_con_iva(precio) AS precio_iva FROM productos ORDER BY id;`

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
DELIMITER //
CREATE FUNCTION fn_precio_con_iva(p_precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_precio * 1.21;
END //
DELIMITER ;

SELECT nombre, precio, fn_precio_con_iva(precio) AS precio_iva
FROM productos ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-04-avanzado/ejercicio-21-funcion-usuario
bash test.sh
```
