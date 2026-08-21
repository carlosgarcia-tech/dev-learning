# Ejercicio 09 — Subconsulta

- **Nivel:** 2/5
- **Tema:** Básico de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `productos` tiene datos. Escribe una subconsulta en el `WHERE`.

1. Muestra `nombre` y `precio` de los productos cuyo precio es mayor que el promedio de todos los precios.
2. Ordena por `precio` descendente.

## Requisitos

- [ ] La consulta contiene una subconsulta `(SELECT AVG(precio) FROM productos)` en el `WHERE`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El promedio se calcula con `SELECT AVG(precio) FROM productos`.
- La subconsulta va entre paréntesis en el `WHERE`: `WHERE precio > (SELECT ...)`.
- Ordena con `ORDER BY precio DESC`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos)
ORDER BY precio DESC;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-02-basico/ejercicio-09-subconsulta
bash test.sh
```
