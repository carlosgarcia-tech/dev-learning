# Ejercicio 04 — LIMIT

- **Nivel:** 1/5
- **Tema:** Fundamentos de MySQL
- **Tiempo estimado:** 15 minutos

## Enunciado

La tabla `productos` ya tiene datos. Escribe las consultas pedidas, unidas con `UNION ALL`.

1. Los 3 productos más caros (muestra `nombre` y `precio`).
2. Los 2 productos con menor stock (muestra `nombre` y `stock`).
3. El primer producto por orden de `id` (muestra `id` y `nombre`).

## Requisitos

- [ ] Usas `ORDER BY` junto con `LIMIT` en cada consulta
- [ ] Las consultas se unen con `UNION ALL`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `ORDER BY precio DESC LIMIT 3` da los 3 más caros.
- `ORDER BY stock ASC LIMIT 2` da los 2 con menos stock.
- Cada subconsulta en un `UNION` debe ir entre paréntesis con su propio `ORDER BY ... LIMIT`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
(SELECT nombre, precio FROM productos ORDER BY precio DESC LIMIT 3)
UNION ALL
(SELECT nombre, stock FROM productos ORDER BY stock ASC LIMIT 2)
UNION ALL
(SELECT id, nombre FROM productos ORDER BY id LIMIT 1);
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-04-limit
bash test.sh
```
