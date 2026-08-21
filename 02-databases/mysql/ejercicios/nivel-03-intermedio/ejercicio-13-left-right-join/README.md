# Ejercicio 13 — LEFT / RIGHT JOIN

- **Nivel:** 3/5
- **Tema:** Intermedio de MySQL
- **Tiempo estimado:** 25 minutos

## Enunciado

Las tablas `clientes` y `pedidos` ya existen. Algunos clientes no tienen pedidos y
algunos pedidos no tienen cliente asignado. Usa LEFT y RIGHT JOIN.

1. **LEFT JOIN**: Lista todos los clientes y, si tienen, sus pedidos. Si un cliente
   no tiene pedidos, muestra `NULL` en las columnas de pedido.
   Columnas: `cliente`, `pedido_id`, `total`.
2. **RIGHT JOIN**: Lista todos los pedidos y, si lo tienen, el nombre del cliente.
   Si un pedido no tiene cliente, muestra `NULL`.
   Columnas: `cliente`, `pedido_id`, `total`.

Une ambos resultados con `UNION ALL`.

## Requisitos

- [ ] Usas `LEFT JOIN` y `RIGHT JOIN`
- [ ] Los clientes sin pedidos aparecen con `NULL` en las columnas de pedido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `LEFT JOIN` devuelve todas las filas de la tabla izquierda (clientes) aunque no
  haya match en la derecha (pedidos).
- `RIGHT JOIN` devuelve todas las filas de la tabla derecha (pedidos) aunque no
  haya match en la izquierda (clientes).
- Usa `ORDER BY` para un orden determinista.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
(SELECT c.nombre AS cliente, p.id AS pedido_id, p.total
 FROM clientes c
 LEFT JOIN pedidos p ON c.id = p.cliente_id
 ORDER BY c.id, p.id)
UNION ALL
(SELECT c.nombre AS cliente, p.id AS pedido_id, p.total
 FROM clientes c
 RIGHT JOIN pedidos p ON c.id = p.cliente_id
 ORDER BY p.id);
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-03-intermedio/ejercicio-13-left-right-join
bash test.sh
```
